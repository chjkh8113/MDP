"""
Batch extract all Konkur PDFs to images with metadata.
"""

import sys
import json
from pathlib import Path

# Add scripts dir to path
sys.path.insert(0, str(Path(__file__).parent))
from extract_konkur_images import extract_pdf_to_images

PDF_DIR = Path(r"C:\Users\Administrator\MDP\resources\konkur-pdfs")
OUTPUT_DIR = Path(r"C:\Users\Administrator\MDP\resources\konkur-images")


def process_all_pdfs():
    """Process all PDF files and create a combined index."""

    # Find all PDFs
    pdf_files = sorted(PDF_DIR.glob("konkur-arshad-computer-*.pdf"))
    print(f"Found {len(pdf_files)} PDF files to process\n")

    all_metadata = []

    for i, pdf_path in enumerate(pdf_files, 1):
        print(f"\n{'='*60}")
        print(f"[{i}/{len(pdf_files)}] Processing: {pdf_path.name}")
        print('='*60)

        try:
            metadata = extract_pdf_to_images(
                pdf_path=str(pdf_path),
                output_dir=str(OUTPUT_DIR),
                zoom=2.0,
                image_format="png"
            )
            all_metadata.append(metadata)
        except Exception as e:
            print(f"ERROR processing {pdf_path.name}: {e}")
            continue

    # Create combined index
    print(f"\n{'='*60}")
    print("Creating combined index...")
    print('='*60)

    combined_index = {
        "total_exams": len(all_metadata),
        "total_pages": sum(m["total_pages"] for m in all_metadata),
        "years": [m["year"] for m in all_metadata],
        "exams": all_metadata
    }

    index_path = OUTPUT_DIR / "index.json"
    with open(index_path, "w", encoding="utf-8") as f:
        json.dump(combined_index, f, ensure_ascii=False, indent=2)

    print(f"\nCombined index saved to: {index_path}")
    print(f"Total exams: {combined_index['total_exams']}")
    print(f"Total pages: {combined_index['total_pages']}")

    return combined_index


if __name__ == "__main__":
    process_all_pdfs()
