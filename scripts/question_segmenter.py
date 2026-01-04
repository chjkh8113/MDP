"""
Question Segmenter for Konkur Exam Pages
Extracts individual questions from full-page exam images.
Uses metadata-driven intelligent splitting with gap detection refinement.
"""

import cv2
import numpy as np
import json
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass, asdict, field
from typing import List, Tuple, Optional, Dict


# Conservative estimate - fewer larger regions to avoid splitting questions
# Better to have 2 questions in one image than 1 question split across 2
SECTION_QUESTIONS_PER_PAGE = {
    "English": 5,       # Short questions, can fit more
    "Mathematics": 3,   # Math has diagrams/formulas
    "Theory & Signals": 3,
    "DS & Algorithms": 3,
    "Hardware": 3,      # Has circuit diagrams
    "Systems": 3,
}


@dataclass
class QuestionRegion:
    """Represents a detected question region."""
    y_start: int
    y_end: int
    height: int
    question_number: int = 0
    confidence: float = 0.0


@dataclass
class QuestionMetadata:
    """Metadata for an extracted question."""
    id: str
    filename: str
    year: int
    question_number: int
    page_source: str
    section: str
    section_en: str
    courses: List[str]
    crop_coords: dict
    tags: List[str]

    def to_dict(self):
        return asdict(self)


class QuestionSegmenter:
    """Segments exam pages into individual questions."""

    def __init__(
        self,
        min_question_height: int = 100,
        max_question_height: int = 600,
        margin: int = 10,
        header_height: int = 120,
        footer_height: int = 60
    ):
        self.min_question_height = min_question_height
        self.max_question_height = max_question_height
        self.margin = margin
        self.header_height = header_height
        self.footer_height = footer_height

    def preprocess(self, img: np.ndarray) -> np.ndarray:
        """Preprocess image for analysis."""
        if len(img.shape) == 3:
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        else:
            gray = img.copy()

        blurred = cv2.GaussianBlur(gray, (5, 5), 0)
        _, binary = cv2.threshold(blurred, 200, 255, cv2.THRESH_BINARY_INV)
        return binary

    def analyze_row_density(self, binary: np.ndarray) -> np.ndarray:
        """Calculate text density per row."""
        height, width = binary.shape
        row_density = np.sum(binary, axis=1) / (width * 255)
        return row_density

    def find_potential_gaps(
        self,
        row_density: np.ndarray,
        threshold: float = 0.02
    ) -> List[Tuple[int, int]]:
        """Find rows with low text density (potential gaps)."""
        is_gap = row_density < threshold

        gaps = []
        in_gap = False
        gap_start = 0

        for y, is_g in enumerate(is_gap):
            if is_g and not in_gap:
                in_gap = True
                gap_start = y
            elif not is_g and in_gap:
                in_gap = False
                gaps.append((gap_start, y))

        return gaps

    def find_question_boundaries_by_gaps(
        self,
        img: np.ndarray,
        expected_questions: int
    ) -> List[Tuple[int, int]]:
        """
        Find question boundaries using large gap detection.
        Uses conservative threshold to avoid splitting on diagram/table gaps.
        """
        height, width = img.shape[:2]
        binary = self.preprocess(img)
        row_density = self.analyze_row_density(binary)

        # Find all gaps
        all_gaps = self.find_potential_gaps(row_density)

        # Filter for VERY large gaps only (>80px) to avoid splitting on
        # internal question gaps (diagrams, tables, option spacing)
        # Real question boundaries typically have 80-120px gaps
        large_gaps = [(s, e) for s, e in all_gaps if e - s > 80]

        # Skip header gap (first gap if it starts near top)
        content_gaps = []
        for s, e in large_gaps:
            # Skip gaps in header area (first 140px)
            if s < 140:
                continue
            # Skip gaps in footer area (last 100px)
            if s > height - 100:
                continue
            content_gaps.append((s, e))

        # Only use gap detection if we found EXACTLY the right number
        # This ensures we don't over-segment pages with complex layouts
        if len(content_gaps) == expected_questions - 1:
            # Use gaps as boundaries
            boundaries = []
            prev_end = self.header_height

            # Sort gaps by position
            content_gaps = sorted(content_gaps, key=lambda x: x[0])

            for gap_start, gap_end in content_gaps:
                gap_center = (gap_start + gap_end) // 2
                boundaries.append((prev_end, gap_center))
                prev_end = gap_center

            # Last question extends to content end
            content_end = height - self.footer_height
            boundaries.append((prev_end, content_end))

            return boundaries

        # Not exact match, return empty to trigger fixed-ratio fallback
        return []

    def refine_boundaries_with_gaps(
        self,
        initial_boundaries: List[Tuple[int, int]],
        gaps: List[Tuple[int, int]],
        tolerance: int = 50
    ) -> List[Tuple[int, int]]:
        """Refine boundaries using detected gaps."""
        if not gaps:
            return initial_boundaries

        refined = []
        for start, end in initial_boundaries:
            # Find nearest gap to the boundary
            best_start = start
            best_end = end

            for gap_start, gap_end in gaps:
                gap_center = (gap_start + gap_end) // 2

                # Adjust start if gap is near
                if abs(gap_center - start) < tolerance:
                    best_start = gap_end

                # Adjust end if gap is near
                if abs(gap_center - end) < tolerance:
                    best_end = gap_start

            refined.append((best_start, best_end))

        return refined

    def smart_split(
        self,
        img_height: int,
        num_questions: int
    ) -> List[Tuple[int, int]]:
        """
        Split page into regions for expected number of questions.
        Accounts for header and footer.
        """
        content_start = self.header_height
        content_end = img_height - self.footer_height
        content_height = content_end - content_start

        question_height = content_height // num_questions

        boundaries = []
        for i in range(num_questions):
            y_start = content_start + i * question_height
            y_end = content_start + (i + 1) * question_height

            # Last question gets remaining space
            if i == num_questions - 1:
                y_end = content_end

            boundaries.append((y_start, y_end))

        return boundaries

    def segment_page(
        self,
        img: np.ndarray,
        expected_questions: int = 4,
        section_type: str = None
    ) -> List[QuestionRegion]:
        """
        Segment a page into question regions.

        Args:
            img: Input image
            expected_questions: Expected number of questions on this page
            section_type: Section name for better estimation
        """
        height, width = img.shape[:2]

        # Determine expected questions
        if section_type and section_type in SECTION_QUESTIONS_PER_PAGE:
            expected_questions = SECTION_QUESTIONS_PER_PAGE[section_type]

        # Try gap-based detection first (more accurate)
        boundaries = self.find_question_boundaries_by_gaps(img, expected_questions)
        used_gap_detection = bool(boundaries)

        # Fall back to smart split if gap detection didn't work
        if not boundaries:
            boundaries = self.smart_split(height, expected_questions)

            # Try to refine with gap detection
            binary = self.preprocess(img)
            row_density = self.analyze_row_density(binary)
            gaps = self.find_potential_gaps(row_density)

            # Filter gaps to find significant ones (>20px)
            significant_gaps = [(s, e) for s, e in gaps if e - s > 20]

            if significant_gaps:
                boundaries = self.refine_boundaries_with_gaps(
                    boundaries, significant_gaps
                )

        # Create QuestionRegion objects
        regions = []
        for i, (y_start, y_end) in enumerate(boundaries):
            # Add margins
            y_start_m = max(0, y_start - self.margin)
            y_end_m = min(height, y_end + self.margin)

            region = QuestionRegion(
                y_start=y_start_m,
                y_end=y_end_m,
                height=y_end_m - y_start_m,
                question_number=i + 1,
                confidence=0.85 if used_gap_detection else 0.7
            )
            regions.append(region)

        return regions

    def extract_questions_from_page(
        self,
        img_path: str,
        output_dir: str,
        page_metadata: dict,
        start_question_num: int
    ) -> List[QuestionMetadata]:
        """
        Extract individual questions from a page image.

        Args:
            img_path: Path to page image
            output_dir: Directory to save questions
            page_metadata: Page metadata (year, section, courses, etc.)
            start_question_num: First question number on this page

        Returns:
            List of metadata for extracted questions
        """
        img_path = Path(img_path)
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        # Load image
        img = cv2.imread(str(img_path))
        if img is None:
            raise ValueError(f"Could not load: {img_path}")

        height, width = img.shape[:2]

        # Get section type for better estimation
        section_type = page_metadata.get("section_en", "")

        # Segment page
        regions = self.segment_page(img, section_type=section_type)

        # Extract and save each question
        metadata_list = []
        question_num = start_question_num

        for region in regions:
            # Crop
            cropped = img[region.y_start:region.y_end, :]

            # Filename
            filename = f"q-{question_num:03d}.png"
            output_path = output_dir / filename

            # Save
            cv2.imwrite(str(output_path), cropped)

            # Metadata
            year = page_metadata.get("year", 0)
            meta = QuestionMetadata(
                id=f"{year}-q-{question_num:03d}",
                filename=filename,
                year=year,
                question_number=question_num,
                page_source=img_path.name,
                section=page_metadata.get("section", ""),
                section_en=section_type,
                courses=page_metadata.get("courses", []),
                crop_coords={
                    "x": 0,
                    "y": region.y_start,
                    "width": width,
                    "height": region.y_end - region.y_start
                },
                tags=self._generate_tags(year, question_num, page_metadata)
            )
            metadata_list.append(meta)
            question_num += 1

        return metadata_list

    def _generate_tags(
        self,
        year: int,
        question_num: int,
        page_metadata: dict
    ) -> List[str]:
        """Generate searchable tags for a question."""
        tags = [
            f"year-{year}",
            f"question-{question_num}",
        ]

        section_en = page_metadata.get("section_en", "")
        if section_en:
            tags.append(section_en.lower().replace(" ", "-").replace("&", "and"))

        for course in page_metadata.get("courses", []):
            tags.append(course.replace(" ", "-"))

        return tags


def process_year(
    year: int,
    images_dir: str,
    output_dir: str
) -> Dict:
    """
    Process all pages for a given year.

    Returns metadata for all extracted questions.
    """
    images_dir = Path(images_dir)
    output_dir = Path(output_dir)

    # Load year metadata
    meta_path = images_dir / str(year) / "metadata.json"
    with open(meta_path, "r", encoding="utf-8") as f:
        year_meta = json.load(f)

    segmenter = QuestionSegmenter()
    all_questions = []
    current_question = 1

    for page in year_meta["pages"]:
        # Skip non-question pages
        if page["section"] in ["cover", "answer_key"]:
            continue

        if page["question_range"] is None:
            continue

        page_num = page["page_number"]
        img_path = images_dir / str(year) / page["filename"]

        print(f"  Processing page {page_num} ({page['section_en']})...")

        try:
            questions = segmenter.extract_questions_from_page(
                str(img_path),
                str(output_dir / str(year)),
                page,
                current_question
            )

            all_questions.extend(questions)
            current_question += len(questions)

        except Exception as e:
            print(f"    Error: {e}")

    # Save year metadata
    year_output_meta = {
        "year": year,
        "total_questions": len(all_questions),
        "extracted_at": datetime.now().isoformat(),
        "questions": [q.to_dict() for q in all_questions]
    }

    meta_out_path = output_dir / str(year) / "metadata.json"
    meta_out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(meta_out_path, "w", encoding="utf-8") as f:
        json.dump(year_output_meta, f, ensure_ascii=False, indent=2)

    return year_output_meta


def test_single_page(img_path: str, output_dir: str = None):
    """Test segmentation on a single page."""
    img_path = Path(img_path)

    img = cv2.imread(str(img_path))
    if img is None:
        print(f"Error: Could not load {img_path}")
        return

    print(f"Testing: {img_path.name}")
    print(f"Size: {img.shape[1]}x{img.shape[0]}")

    # Extract year from path
    year = 0
    for part in img_path.parts:
        if part.isdigit() and len(part) == 4:
            year = int(part)
            break

    segmenter = QuestionSegmenter()
    regions = segmenter.segment_page(img, expected_questions=4)

    print(f"\nDetected {len(regions)} regions:")
    for r in regions:
        print(f"  Q{r.question_number}: y={r.y_start}-{r.y_end} ({r.height}px)")

    if output_dir:
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        page_meta = {
            "year": year,
            "section": "Test",
            "section_en": "DS & Algorithms",
            "courses": ["ساختمان داده"]
        }

        questions = segmenter.extract_questions_from_page(
            str(img_path),
            str(output_dir),
            page_meta,
            start_question_num=60
        )

        print(f"\nExtracted {len(questions)} questions to {output_dir}")
        for q in questions:
            print(f"  {q.filename}: Q{q.question_number} ({q.crop_coords['height']}px)")


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        test_path = r"C:\Users\Administrator\MDP\resources\konkur-images\1402\page-13.png"
        output_path = r"C:\Users\Administrator\MDP\resources\konkur-questions\test"
    else:
        test_path = sys.argv[1]
        output_path = sys.argv[2] if len(sys.argv) > 2 else None

    test_single_page(test_path, output_path)
