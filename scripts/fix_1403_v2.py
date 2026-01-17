"""
Corrected fix for Q87-Q96 based on pixel-level debug analysis.
Verified exact y-coordinates where each question starts/ends.
"""

import cv2
import json
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
crop_coords = {}

def extract(img, name, y_start, y_end, page):
    q = img[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'{name}.png'), q)
    crop_coords[name] = {
        'y_start': y_start,
        'y_end': y_end,
        'height': y_end - y_start,
        'source_page': page
    }
    print(f"{name}: y={y_start}-{y_end} ({y_end - y_start}px)")


# Page 21: Q87-Q88
# Debug shows Q87 options extend to ~y=1110, Q88 options extend to ~y=1470
print("=== Page 21 ===")
p21 = cv2.imread('resources/konkur-images/1403/page-21.png')
extract(p21, 'q-087', 720, 1110, 'page-21')
extract(p21, 'q-088', 1115, 1480, 'page-21')  # Extended to include all 4 options

# Page 22: Q90-Q92
# Debug shows:
# - Q90 circuit (V_DD label) extends to ~y=815
# - Q91 starts at ~y=830
# - Q91 options extend to ~y=1185
# - Q92 starts at ~y=1195
print("\n=== Page 22 ===")
p22 = cv2.imread('resources/konkur-images/1403/page-22.png')
extract(p22, 'q-090', 290, 820, 'page-22')   # Extended to include V_DD label
extract(p22, 'q-091', 830, 1185, 'page-22')  # Start after V_DD, include all options
extract(p22, 'q-092', 1195, 1560, 'page-22') # Starts after Q91's options

# Page 23: Q93-Q95
# Debug shows:
# - Q93 axis (Vin numbers) ends at ~y=485
# - Q94 starts at y=500
# - Q94 ground symbols end at ~y=980
# - Q95 starts at y=1000
print("\n=== Page 23 ===")
p23 = cv2.imread('resources/konkur-images/1403/page-23.png')
extract(p23, 'q-093', 160, 490, 'page-23')   # Extended to include full graph axis
extract(p23, 'q-094', 500, 990, 'page-23')   # Starts after Q93's axis, includes full circuit
extract(p23, 'q-095', 1000, 1350, 'page-23') # Starts after Q94's ground symbols

# Page 24: Q96
# Debug shows:
# - Header ends at ~y=180
# - Q96 starts at ~y=210
print("\n=== Page 24 ===")
p24 = cv2.imread('resources/konkur-images/1403/page-24.png')
extract(p24, 'q-096', 210, 520, 'page-24')   # Starts after header

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

print(f"Updated {len(crop_coords)} questions")
print("\nDone!")
