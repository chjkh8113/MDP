"""
Final fix for Q86-Q100 with precise boundaries.
"""

import cv2
import json
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
crop_coords = {}

def extract(img, name, y_start, y_end, page):
    q = img[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'{name}.png'), q)
    crop_coords[name] = {'y_start': y_start, 'y_end': y_end, 'height': y_end - y_start, 'source_page': page}
    print(f"{name}: y={y_start}-{y_end} ({q.shape[0]}px)")

# Page 21
print("=== Page 21 ===")
p21 = cv2.imread('resources/konkur-images/1403/page-21.png')
extract(p21, 'q-086', 520, 720, 'page-21')
extract(p21, 'q-087', 720, 1010, 'page-21')
extract(p21, 'q-088', 1010, 1310, 'page-21')

# Page 22 - adjusted boundaries
print("\n=== Page 22 ===")
p22 = cv2.imread('resources/konkur-images/1403/page-22.png')
extract(p22, 'q-089', 140, 290, 'page-22')
extract(p22, 'q-090', 290, 735, 'page-22')
extract(p22, 'q-091', 735, 1000, 'page-22')
extract(p22, 'q-092', 1000, 1560, 'page-22')

# Page 23 - adjusted boundaries
print("\n=== Page 23 ===")
p23 = cv2.imread('resources/konkur-images/1403/page-23.png')
extract(p23, 'q-093', 140, 435, 'page-23')
extract(p23, 'q-094', 435, 800, 'page-23')
extract(p23, 'q-095', 800, 1200, 'page-23')

# Page 24 - adjusted for options
print("\n=== Page 24 ===")
p24 = cv2.imread('resources/konkur-images/1403/page-24.png')
extract(p24, 'q-096', 140, 400, 'page-24')
extract(p24, 'q-097', 400, 620, 'page-24')
extract(p24, 'q-098', 620, 790, 'page-24')
extract(p24, 'q-099', 790, 1060, 'page-24')
extract(p24, 'q-100', 1060, 1220, 'page-24')

# Update metadata
print("\n=== Updating metadata ===")
meta_path = output_dir / 'metadata.json'
with open(meta_path, 'r', encoding='utf-8') as f:
    meta = json.load(f)
for q in meta['questions']:
    key = f"q-{q['number']:03d}"
    if key in crop_coords:
        q['crop_coords'] = crop_coords[key]
with open(meta_path, 'w', encoding='utf-8') as f:
    json.dump(meta, f, ensure_ascii=False, indent=2)

print(f"Updated {len(crop_coords)} questions\nDone!")
