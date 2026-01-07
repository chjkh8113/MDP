"""
AI-Guided Question Extractor
Extracts questions using manually defined boundaries from JSON.
"""

import cv2
import json
from pathlib import Path


def extract_questions(json_path: str, images_dir: str, output_dir: str):
    """Extract questions based on AI-analyzed boundaries."""

    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    year = data['year']
    images_dir = Path(images_dir) / str(year)
    output_dir = Path(output_dir) / str(year)
    output_dir.mkdir(parents=True, exist_ok=True)

    extracted = []

    for page_name, page_data in data['pages'].items():
        img_path = images_dir / f"{page_name}.png"

        if not img_path.exists():
            print(f"Image not found: {img_path}")
            continue

        img = cv2.imread(str(img_path))
        if img is None:
            print(f"Could not load: {img_path}")
            continue

        height, width = img.shape[:2]
        print(f"\nProcessing {page_name} ({width}x{height})")

        for q in page_data['questions']:
            q_num = q['number']
            y_start = max(0, q['y_start'] - 5)  # Small margin
            y_end = min(height, q['y_end'] + 5)

            # Crop question
            cropped = img[y_start:y_end, :]

            # Save
            filename = f"q-{q_num:03d}.png"
            out_path = output_dir / filename
            cv2.imwrite(str(out_path), cropped)

            extracted.append({
                "number": q_num,
                "filename": filename,
                "section": q.get('section', ''),
                "topic": q.get('topic', ''),
                "source_page": page_name,
                "crop": {"y_start": y_start, "y_end": y_end, "height": y_end - y_start}
            })

            print(f"  Q{q_num}: {y_end - y_start}px - {q.get('topic', '')[:40]}")

    # Save metadata
    meta_path = output_dir / "metadata.json"
    with open(meta_path, 'w', encoding='utf-8') as f:
        json.dump({
            "year": year,
            "total_questions": len(extracted),
            "questions": extracted
        }, f, ensure_ascii=False, indent=2)

    print(f"\nExtracted {len(extracted)} questions to {output_dir}")
    return extracted


if __name__ == "__main__":
    extract_questions(
        json_path="scripts/ai_segmentation/1404_questions.json",
        images_dir="resources/konkur-images",
        output_dir="resources/konkur-questions"
    )
