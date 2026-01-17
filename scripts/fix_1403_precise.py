"""
Final precise fix for Q87-Q96 based on pixel-level debug image analysis.
Each question includes: full question text, all images/circuits, ALL 4 options.
No bleeding from adjacent questions. Headers trimmed.
"""

import cv2
import json
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
crop_coords = {}

def extract_and_save(img, name, y_start, y_end, page_name):
    """Extract question image and record coordinates."""
    q = img[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'{name}.png'), q)
    crop_coords[name] = {
        'y_start': y_start,
        'y_end': y_end,
        'height': y_end - y_start,
        'source_page': page_name
    }
    print(f"{name}: y={y_start}-{y_end} ({y_end - y_start}px)")


def fix_page21():
    """Fix Q87-Q88 on page 21.

    Debug findings:
    - p21_y1060: Q87 options 3,4 (DRTAR U RET) visible
    - p21_y1100: Q87 option 4 still visible
    - Q87 options extend to y≈1110
    - Q88 must start at y≈1115
    """
    print("\n=== Page 21: Q87-Q88 ===")
    img = cv2.imread('resources/konkur-images/1403/page-21.png')

    # Q87: Start at 720, extend to 1110 to include all 4 options
    extract_and_save(img, 'q-087', 720, 1110, 'page-21')

    # Q88: Start after Q87's options (y=1115), extend to end of page content
    extract_and_save(img, 'q-088', 1115, 1420, 'page-21')


def fix_page22():
    """Fix Q90-Q92 on page 22.

    Debug findings:
    - p22_y740: Q90's circuit still visible
    - p22_y760: Q90 circuit ends around here
    - p22_y1040: Q91's options START here
    - p22_y1060: Q91 option 1 visible
    - Q91 must extend past 1100 to include all options
    """
    print("\n=== Page 22: Q90-Q92 ===")
    img = cv2.imread('resources/konkur-images/1403/page-22.png')

    # Q90: Circuit extends to y≈800
    extract_and_save(img, 'q-090', 290, 800, 'page-22')

    # Q91: Start at 805, options end at y≈1100
    extract_and_save(img, 'q-091', 805, 1100, 'page-22')

    # Q92: Start at 1105, include full circuit + options
    extract_and_save(img, 'q-092', 1105, 1560, 'page-22')


def fix_page23():
    """Fix Q93-Q95 on page 23.

    Debug findings:
    - p23_y140: Page header visible
    - p23_y160: Q93 starts here (۹۳-)
    - p23_y400-420: Q93's graph bottom with V_DD, option 4 visible
    - p23_y740: Q94's circuit with options VT/2VT visible
    - Header ends at y≈155, Q93 starts at y≈160
    """
    print("\n=== Page 23: Q93-Q95 ===")
    img = cv2.imread('resources/konkur-images/1403/page-23.png')

    # Q93: Start at 160 (after header), extend to 440 for full graph + options
    extract_and_save(img, 'q-093', 160, 445, 'page-23')

    # Q94: Start at 450, circuit + options end at y≈760
    extract_and_save(img, 'q-094', 450, 765, 'page-23')

    # Q95: Start at 770, extend to 1150 for circuit + all options
    extract_and_save(img, 'q-095', 770, 1150, 'page-23')


def fix_page24():
    """Fix Q96 on page 24.

    Debug findings:
    - p24_y160: Section header still visible
    - Section header ends at y≈170
    - Q96 should start at y≈175
    """
    print("\n=== Page 24: Q96 ===")
    img = cv2.imread('resources/konkur-images/1403/page-24.png')

    # Q96: Start at 175 (after section header), keep current end
    extract_and_save(img, 'q-096', 175, 520, 'page-24')


def update_metadata():
    """Update metadata.json with new crop coordinates."""
    print("\n=== Updating metadata ===")
    meta_path = output_dir / 'metadata.json'

    with open(meta_path, 'r', encoding='utf-8') as f:
        meta = json.load(f)

    updated_count = 0
    for q in meta['questions']:
        key = f"q-{q['number']:03d}"
        if key in crop_coords:
            q['crop_coords'] = crop_coords[key]
            updated_count += 1

    with open(meta_path, 'w', encoding='utf-8') as f:
        json.dump(meta, f, ensure_ascii=False, indent=2)

    print(f"Updated {updated_count} questions in metadata")


if __name__ == '__main__':
    print("=" * 50)
    print("Fixing Q87-Q96 with precise pixel boundaries")
    print("=" * 50)

    fix_page21()
    fix_page22()
    fix_page23()
    fix_page24()
    update_metadata()

    print("\n" + "=" * 50)
    print("Done! Please verify the extracted images.")
    print("=" * 50)
