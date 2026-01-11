"""
Fix Q86-Q100 extraction - v3 with precise boundaries.
Each question must:
1. NOT include previous question's content
2. Include ALL 4 options
"""

import cv2
import json
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
crop_coords = {}

def extract_question(img, name, y_start, y_end, page_name):
    q = img[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'{name}.png'), q)
    crop_coords[name] = {'y_start': y_start, 'y_end': y_end, 'height': y_end - y_start, 'source_page': page_name}
    print(f"{name}: y={y_start}-{y_end} ({q.shape[0]}px)")

# Page 21: Q86-Q88
print("=== Page 21 ===")
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')

# Q86: y=520-720 (ALU speedup, all 4 options)
extract_question(img_p21, 'q-086', 520, 720, 'page-21')

# Q87: y=720-1010 (Subroutine INDRCT with 4 tables)
extract_question(img_p21, 'q-087', 720, 1010, 'page-21')

# Q88: y=1010-1310 (Cache MRU policy)
extract_question(img_p21, 'q-088', 1010, 1310, 'page-21')


# Page 22: Q89-Q92
print("\n=== Page 22 ===")
img_p22 = cv2.imread('resources/konkur-images/1403/page-22.png')

# Q89: y=140-275 (Booth algorithm, all 4 options)
extract_question(img_p22, 'q-089', 140, 275, 'page-22')

# Q90: y=275-720 (CMOS circuit with full diagram)
extract_question(img_p22, 'q-090', 275, 720, 'page-22')

# Q91: y=720-985 (NMOS power consumption)
extract_question(img_p22, 'q-091', 720, 985, 'page-22')

# Q92: y=985-1560 (VOH/VOL with circuit diagram)
extract_question(img_p22, 'q-092', 985, 1560, 'page-22')


# Page 23: Q93-Q95
print("\n=== Page 23 ===")
img_p23 = cv2.imread('resources/konkur-images/1403/page-23.png')

# Q93: y=140-420 (CMOS inverter graph + 4 options)
extract_question(img_p23, 'q-093', 140, 420, 'page-23')

# Q94: y=420-780 (Vout calculation with circuit)
extract_question(img_p23, 'q-094', 420, 780, 'page-23')

# Q95: y=780-1180 (Charge sharing with circuit)
extract_question(img_p23, 'q-095', 780, 1180, 'page-23')


# Page 24: Q96-Q100
print("\n=== Page 24 ===")
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

# Q96: y=140-385 (Thread statements with section header)
extract_question(img_p24, 'q-096', 140, 385, 'page-24')

# Q97: y=385-600 (Round Robin scheduling)
extract_question(img_p24, 'q-097', 385, 600, 'page-24')

# Q98: y=600-770 (Kernel operations)
extract_question(img_p24, 'q-098', 600, 770, 'page-24')

# Q99: y=770-1040 (Virtual memory page table)
extract_question(img_p24, 'q-099', 770, 1040, 'page-24')

# Q100: y=1040-1200 (Convoy effect)
extract_question(img_p24, 'q-100', 1040, 1200, 'page-24')


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
