"""
Accurate fix for Q87-Q96 based on detailed page analysis.
Each question must include: full question text, all images/circuits, ALL 4 options.
No bleeding from adjacent questions.
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
    return q


def fix_page21():
    """Fix Q87-Q88 on page 21.

    Issues:
    - Q87: missed options 3,4 (current: y=720-1010)
    - Q88: shows Q87's options at top, own options trimmed (current: y=1010-1310)

    Solution: Extend Q87, shift Q88 start later.
    """
    print("\n=== Page 21: Q87-Q88 ===")
    img = cv2.imread('resources/konkur-images/1403/page-21.png')

    # Q87: Extend end to include options 3,4
    # Agent says Q87 has code tables + 4 options
    extract_and_save(img, 'q-087', 720, 1050, 'page-21')

    # Q88: Start after Q87's options, extend for full content
    extract_and_save(img, 'q-088', 1055, 1350, 'page-21')


def fix_page22():
    """Fix Q90-Q92 on page 22.

    Issues:
    - Q90: circuit image cut off (current: y=290-735)
    - Q91: shows Q90's image, missed ALL 4 options (current: y=735-1000)
    - Q92: shows Q91's options, missed ALL 4 options (current: y=1000-1560)

    Solution: Extend Q90 slightly, shift Q91/Q92 starts, extend ends.
    """
    print("\n=== Page 22: Q90-Q92 ===")
    img = cv2.imread('resources/konkur-images/1403/page-22.png')

    # Q90: Circuit + options (circuit is large, extends to ~730)
    extract_and_save(img, 'q-090', 290, 745, 'page-22')

    # Q91: Start after Q90's circuit, include all 4 options
    # Agent says Q91 options at y=870-995
    extract_and_save(img, 'q-091', 750, 1050, 'page-22')

    # Q92: Start after Q91, include circuit + all 4 options
    # Agent says Q92 circuit ends at y=1385, options end at y=1190
    extract_and_save(img, 'q-092', 1055, 1430, 'page-22')


def fix_page23():
    """Fix Q93-Q95 on page 23.

    Issues:
    - Q93: bottom too much trimmed, graph not clear (current: y=140-435)
    - Q94: shows Q93's image, missed own circuit (current: y=435-800)
    - Q95: shows Q94's circuit, missed options and own circuit (current: y=800-1200)

    Solution: Page header ends at y=55 (not 140). Adjust all boundaries.
    Agent analysis:
    - Q93: y=55-385 (graph ends at 375)
    - Q94: y=390-730 (circuit ends at 720)
    - Q95: y=740-1105 (circuit ends at 1095)
    """
    print("\n=== Page 23: Q93-Q95 ===")
    img = cv2.imread('resources/konkur-images/1403/page-23.png')

    # Q93: Start earlier (y=55), include full graph
    extract_and_save(img, 'q-093', 55, 390, 'page-23')

    # Q94: Start after Q93's graph, include full circuit
    extract_and_save(img, 'q-094', 395, 735, 'page-23')

    # Q95: Start after Q94's circuit, include full circuit + options
    extract_and_save(img, 'q-095', 740, 1110, 'page-23')


def fix_page24():
    """Fix Q96 on page 24.

    Issue:
    - Q96: includes page header and section header (current: y=35-520)

    Solution: Start at y=100 to skip both header lines.
    Agent says:
    - Page header: y=0-35
    - Section header: y=35-75
    - Q96 "۹۶-" starts at y=100
    """
    print("\n=== Page 24: Q96 ===")
    img = cv2.imread('resources/konkur-images/1403/page-24.png')

    # Q96: Skip page header and section header
    extract_and_save(img, 'q-096', 100, 520, 'page-24')


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
    print("Fixing Q87-Q96 with accurate boundaries")
    print("=" * 50)

    fix_page21()
    fix_page22()
    fix_page23()
    fix_page24()
    update_metadata()

    print("\n" + "=" * 50)
    print("Done! Please verify the extracted images.")
    print("=" * 50)
