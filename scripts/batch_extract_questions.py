"""
Batch extract individual questions from all Konkur exam page images.
Creates organized folder structure with metadata for each year.
"""

import sys
import json
from pathlib import Path
from datetime import datetime

sys.path.insert(0, str(Path(__file__).parent))
from question_segmenter import QuestionSegmenter, process_year

IMAGES_DIR = Path(r"C:\Users\Administrator\MDP\resources\konkur-images")
OUTPUT_DIR = Path(r"C:\Users\Administrator\MDP\resources\konkur-questions")


def extract_all_years():
    """Extract questions from all years and create combined index."""

    # Find all year directories
    year_dirs = sorted([d for d in IMAGES_DIR.iterdir() if d.is_dir() and d.name.isdigit()])

    print(f"Found {len(year_dirs)} years to process")
    print(f"Output directory: {OUTPUT_DIR}\n")

    all_years_meta = []
    total_questions = 0

    for i, year_dir in enumerate(year_dirs, 1):
        year = int(year_dir.name)

        print(f"\n{'='*60}")
        print(f"[{i}/{len(year_dirs)}] Processing year {year}")
        print('='*60)

        try:
            year_meta = process_year(
                year=year,
                images_dir=str(IMAGES_DIR),
                output_dir=str(OUTPUT_DIR)
            )

            all_years_meta.append({
                "year": year,
                "total_questions": year_meta["total_questions"],
                "extracted_at": year_meta["extracted_at"]
            })

            total_questions += year_meta["total_questions"]
            print(f"  Extracted {year_meta['total_questions']} question images")

        except Exception as e:
            print(f"  ERROR: {e}")
            continue

    # Create combined index
    print(f"\n{'='*60}")
    print("Creating combined index...")
    print('='*60)

    combined_index = {
        "total_years": len(all_years_meta),
        "total_questions": total_questions,
        "extracted_at": datetime.now().isoformat(),
        "years": sorted([m["year"] for m in all_years_meta]),
        "by_year": {str(m["year"]): m for m in all_years_meta}
    }

    index_path = OUTPUT_DIR / "index.json"
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    with open(index_path, "w", encoding="utf-8") as f:
        json.dump(combined_index, f, ensure_ascii=False, indent=2)

    print(f"\nCombined index saved to: {index_path}")
    print(f"Total years processed: {combined_index['total_years']}")
    print(f"Total question images: {combined_index['total_questions']}")

    return combined_index


if __name__ == "__main__":
    extract_all_years()
