"""
Fix Q86-Q100 extraction - v2 with correct header offset (y=140).
All pages have headers ending at approximately y=140.
"""

import cv2
import json
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
crop_coords = {}

def extract_question(img, name, y_start, y_end, page_name):
    """Extract a question and record coordinates."""
    q = img[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'{name}.png'), q)
    crop_coords[name] = {
        'y_start': y_start,
        'y_end': y_end,
        'height': y_end - y_start,
        'source_page': page_name
    }
    print(f"{name}: y={y_start}-{y_end} ({q.shape[0]}px)")

# Page 21: Q86-Q88 (Q85 already fixed at y=140-520)
print("=== Page 21 ===")
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')

# Q86: y=520-710 (include all 4 options)
extract_question(img_p21, 'q-086', 520, 710, 'page-21')

# Q87: y=710-1000 (Subroutine tables)
extract_question(img_p21, 'q-087', 710, 1000, 'page-21')

# Q88: y=1000-1300 (Cache MRU)
extract_question(img_p21, 'q-088', 1000, 1300, 'page-21')


# Page 22: Q89-Q92 (header ends at y=140)
print("\n=== Page 22 ===")
img_p22 = cv2.imread('resources/konkur-images/1403/page-22.png')

# Q89: Booth algorithm (y=140-260)
extract_question(img_p22, 'q-089', 140, 260, 'page-22')

# Q90: CMOS circuit (y=260-700)
extract_question(img_p22, 'q-090', 260, 700, 'page-22')

# Q91: NMOS power (y=700-970)
extract_question(img_p22, 'q-091', 700, 970, 'page-22')

# Q92: VOH/VOL (y=970-1550)
extract_question(img_p22, 'q-092', 970, 1550, 'page-22')


# Page 23: Q93-Q95 (header ends at y=140)
print("\n=== Page 23 ===")
img_p23 = cv2.imread('resources/konkur-images/1403/page-23.png')

# Q93: CMOS inverter (y=140-400)
extract_question(img_p23, 'q-093', 140, 400, 'page-23')

# Q94: Vout calculation (y=400-760)
extract_question(img_p23, 'q-094', 400, 760, 'page-23')

# Q95: Charge sharing (y=760-1150)
extract_question(img_p23, 'q-095', 760, 1150, 'page-23')


# Page 24: Q96-Q100 (header + section header ends at y=140)
print("\n=== Page 24 ===")
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

# Q96: Thread statements (y=140-370)
extract_question(img_p24, 'q-096', 140, 370, 'page-24')

# Q97: Round Robin (y=370-580)
extract_question(img_p24, 'q-097', 370, 580, 'page-24')

# Q98: Kernel operations (y=580-750)
extract_question(img_p24, 'q-098', 580, 750, 'page-24')

# Q99: Virtual memory (y=750-1020)
extract_question(img_p24, 'q-099', 750, 1020, 'page-24')

# Q100: Convoy effect (y=1020-1180)
extract_question(img_p24, 'q-100', 1020, 1180, 'page-24')


# Update metadata
print("\n=== Updating metadata ===")
metadata_path = output_dir / 'metadata.json'
with open(metadata_path, 'r', encoding='utf-8') as f:
    metadata = json.load(f)

for q in metadata['questions']:
    q_name = f"q-{q['number']:03d}"
    if q_name in crop_coords:
        q['crop_coords'] = crop_coords[q_name]

with open(metadata_path, 'w', encoding='utf-8') as f:
    json.dump(metadata, f, ensure_ascii=False, indent=2)

print(f"Updated {len(crop_coords)} questions")
print("\nDone!")
