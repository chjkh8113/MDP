"""
Konkur PDF to Image Extractor with Metadata Tagging
Extracts pages from Konkur exam PDFs and creates searchable metadata.
"""

import fitz  # PyMuPDF
import json
import os
from pathlib import Path
from datetime import datetime

# Exam structure based on کنکور ارشد کامپیوتر format
# This defines question ranges and their subjects
EXAM_SECTIONS = {
    "زبان عمومی و تخصصی": {
        "name_en": "English",
        "question_range": (1, 25),
        "courses": ["زبان انگلیسی"]
    },
    "ریاضیات": {
        "name_en": "Mathematics",
        "question_range": (26, 45),
        "courses": ["ریاضی عمومی", "آمار و احتمال", "ریاضیات گسسته"]
    },
    "دروس تخصصی ۱": {
        "name_en": "Theory & Signals",
        "question_range": (46, 55),
        "courses": ["نظریه زبان‌ها و ماشین‌ها", "سیگنال‌ها و سیستم‌ها"]
    },
    "دروس تخصصی ۲": {
        "name_en": "DS & Algorithms",
        "question_range": (56, 75),
        "courses": ["ساختمان داده", "طراحی الگوریتم", "هوش مصنوعی"]
    },
    "دروس تخصصی ۳": {
        "name_en": "Hardware",
        "question_range": (76, 95),
        "courses": ["مدار منطقی", "معماری کامپیوتر", "الکترونیک دیجیتال"]
    },
    "دروس تخصصی ۴": {
        "name_en": "Systems",
        "question_range": (96, 115),
        "courses": ["سیستم عامل", "شبکه‌های کامپیوتری", "پایگاه داده"]
    }
}

# Approximate page mapping for question sections (varies by year)
# Format: (start_page, end_page) - 1-indexed
PAGE_SECTION_MAP = {
    "cover": (1, 1),
    "زبان عمومی و تخصصی": (2, 5),
    "ریاضیات": (6, 9),
    "دروس تخصصی ۱": (10, 12),
    "دروس تخصصی ۲": (13, 17),
    "دروس تخصصی ۳": (18, 22),
    "دروس تخصصی ۴": (23, 27),
    "answer_key": (28, 31)
}


def extract_year_from_filename(filename: str) -> int:
    """Extract year from filename like 'konkur-arshad-computer-1402.pdf'"""
    import re
    match = re.search(r'(\d{4})\.pdf$', filename)
    if match:
        return int(match.group(1))
    return 0


def get_section_for_page(page_num: int, total_pages: int) -> dict:
    """
    Determine which section a page belongs to based on page number.
    Returns section info with tags.
    """
    # Adjust ratios based on total pages
    ratio = page_num / total_pages

    if page_num == 1:
        return {
            "section": "cover",
            "section_en": "Cover Page",
            "tags": ["cover", "info", "exam-structure"],
            "courses": [],
            "question_range": None
        }
    elif ratio < 0.15:
        section = "زبان عمومی و تخصصی"
    elif ratio < 0.30:
        section = "ریاضیات"
    elif ratio < 0.40:
        section = "دروس تخصصی ۱"
    elif ratio < 0.55:
        section = "دروس تخصصی ۲"
    elif ratio < 0.70:
        section = "دروس تخصصی ۳"
    elif ratio < 0.85:
        section = "دروس تخصصی ۴"
    else:
        return {
            "section": "answer_key",
            "section_en": "Answer Key",
            "tags": ["answers", "answer-key", "solutions"],
            "courses": [],
            "question_range": None
        }

    section_info = EXAM_SECTIONS.get(section, {})
    return {
        "section": section,
        "section_en": section_info.get("name_en", "Unknown"),
        "tags": [
            section_info.get("name_en", "").lower().replace(" ", "-"),
            "questions",
            *[c.replace(" ", "-") for c in section_info.get("courses", [])]
        ],
        "courses": section_info.get("courses", []),
        "question_range": section_info.get("question_range")
    }


def extract_pdf_to_images(
    pdf_path: str,
    output_dir: str,
    zoom: float = 2.0,
    image_format: str = "png"
) -> dict:
    """
    Extract all pages from a PDF as images with metadata.

    Args:
        pdf_path: Path to the PDF file
        output_dir: Directory to save images
        zoom: Zoom factor for image quality (2.0 = 2x resolution)
        image_format: Output format (png or jpg)

    Returns:
        Dictionary with extraction results and metadata
    """
    pdf_path = Path(pdf_path)
    output_dir = Path(output_dir)

    # Extract year from filename
    year = extract_year_from_filename(pdf_path.name)

    # Create year-specific output directory
    year_dir = output_dir / str(year)
    year_dir.mkdir(parents=True, exist_ok=True)

    # Open PDF
    doc = fitz.open(pdf_path)
    total_pages = doc.page_count

    # Metadata for all pages
    metadata = {
        "source_file": pdf_path.name,
        "year": year,
        "total_pages": total_pages,
        "extracted_at": datetime.now().isoformat(),
        "exam_type": "کنکور ارشد کامپیوتر",
        "exam_type_en": "Computer Engineering Masters Entrance Exam",
        "pages": []
    }

    print(f"Extracting {total_pages} pages from {pdf_path.name}...")

    for page_num in range(total_pages):
        page = doc[page_num]

        # Get section info for this page
        section_info = get_section_for_page(page_num + 1, total_pages)

        # Create image filename
        image_filename = f"page-{page_num + 1:02d}.{image_format}"
        image_path = year_dir / image_filename

        # Convert page to image
        matrix = fitz.Matrix(zoom, zoom)
        pix = page.get_pixmap(matrix=matrix)
        pix.save(str(image_path))

        # Build page metadata
        page_meta = {
            "page_number": page_num + 1,
            "filename": image_filename,
            "path": str(image_path.relative_to(output_dir)),
            "width": pix.width,
            "height": pix.height,
            "year": year,
            "section": section_info["section"],
            "section_en": section_info["section_en"],
            "courses": section_info["courses"],
            "question_range": section_info["question_range"],
            "tags": [
                f"year-{year}",
                f"page-{page_num + 1}",
                *section_info["tags"]
            ]
        }

        metadata["pages"].append(page_meta)
        print(f"  Page {page_num + 1}/{total_pages}: {section_info['section_en']}")

    doc.close()

    # Save metadata JSON
    metadata_path = year_dir / "metadata.json"
    with open(metadata_path, "w", encoding="utf-8") as f:
        json.dump(metadata, f, ensure_ascii=False, indent=2)

    print(f"\nSaved {total_pages} images to {year_dir}")
    print(f"Metadata saved to {metadata_path}")

    return metadata


def search_by_tag(metadata: dict, tag: str) -> list:
    """Search pages by tag."""
    results = []
    for page in metadata["pages"]:
        if tag.lower() in [t.lower() for t in page["tags"]]:
            results.append(page)
    return results


def search_by_course(metadata: dict, course: str) -> list:
    """Search pages by course name."""
    results = []
    for page in metadata["pages"]:
        if any(course in c for c in page["courses"]):
            results.append(page)
    return results


if __name__ == "__main__":
    import sys

    # Default paths
    PDF_DIR = Path(r"C:\Users\Administrator\MDP\resources\konkur-pdfs")
    OUTPUT_DIR = Path(r"C:\Users\Administrator\MDP\resources\konkur-images")

    # Test with 1402 exam
    test_pdf = PDF_DIR / "konkur-arshad-computer-1402.pdf"

    if len(sys.argv) > 1:
        test_pdf = Path(sys.argv[1])

    if not test_pdf.exists():
        print(f"Error: PDF not found: {test_pdf}")
        sys.exit(1)

    # Extract images
    metadata = extract_pdf_to_images(
        pdf_path=str(test_pdf),
        output_dir=str(OUTPUT_DIR),
        zoom=2.0,
        image_format="png"
    )

    # Demo: Search by tags
    print("\n" + "="*50)
    print("Tag Search Demo:")
    print("="*50)

    # Find Data Structure pages
    ds_pages = search_by_tag(metadata, "ds")
    print(f"\nPages tagged 'DS & Algorithms': {len(ds_pages)}")
    for p in ds_pages[:3]:
        print(f"  - Page {p['page_number']}: {p['section']}")

    # Find by course
    ds_course = search_by_course(metadata, "ساختمان داده")
    print(f"\nPages with 'ساختمان داده' course: {len(ds_course)}")
    for p in ds_course[:3]:
        print(f"  - Page {p['page_number']}: {p['courses']}")
