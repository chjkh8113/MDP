"""
Fix Q86-Q100 extraction for 1403 exam.
Based on visual analysis of pages 21-24.

Updates both question images AND metadata with crop_coords.
"""

import cv2
import json
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
output_dir.mkdir(parents=True, exist_ok=True)

# Store crop coordinates for metadata
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
    return q

# Page 21: Q86-Q88
print("=== Page 21 ===")
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')
print(f"Dimensions: {img_p21.shape}")

# Q86: ALU speedup (starts after Q85 table ends)
extract_question(img_p21, 'q-086', 520, 700, 'page-21')

# Q87: Subroutine INDRCT (has 4 option tables)
extract_question(img_p21, 'q-087', 700, 990, 'page-21')

# Q88: Cache MRU policy (long question)
extract_question(img_p21, 'q-088', 990, 1280, 'page-21')


# Page 22: Q89-Q92
print("\n=== Page 22 ===")
img_p22 = cv2.imread('resources/konkur-images/1403/page-22.png')
print(f"Dimensions: {img_p22.shape}")

# Q89: Booth algorithm (short, near top)
extract_question(img_p22, 'q-089', 40, 150, 'page-22')

# Q90: CMOS circuit output function (has large circuit diagram)
extract_question(img_p22, 'q-090', 150, 680, 'page-22')

# Q91: NMOS/CMOS power consumption
extract_question(img_p22, 'q-091', 680, 930, 'page-22')

# Q92: VOH/VOL circuit analysis (has circuit diagram)
extract_question(img_p22, 'q-092', 930, 1500, 'page-22')


# Page 23: Q93-Q95
print("\n=== Page 23 ===")
img_p23 = cv2.imread('resources/konkur-images/1403/page-23.png')
print(f"Dimensions: {img_p23.shape}")

# Q93: CMOS inverter power (has graph)
extract_question(img_p23, 'q-093', 40, 350, 'page-23')

# Q94: Vout calculation (has circuit diagram)
extract_question(img_p23, 'q-094', 350, 720, 'page-23')

# Q95: Charge sharing (has circuit diagram)
extract_question(img_p23, 'q-095', 720, 1120, 'page-23')


# Page 24: Q96-Q100
print("\n=== Page 24 ===")
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')
print(f"Dimensions: {img_p24.shape}")

# Q96: Thread statements (has section header at top)
extract_question(img_p24, 'q-096', 70, 310, 'page-24')

# Q97: Round Robin scheduling
extract_question(img_p24, 'q-097', 310, 530, 'page-24')

# Q98: Kernel operations
extract_question(img_p24, 'q-098', 530, 690, 'page-24')

# Q99: Virtual memory page table
extract_question(img_p24, 'q-099', 690, 960, 'page-24')

# Q100: Convoy effect
extract_question(img_p24, 'q-100', 960, 1120, 'page-24')


# Update metadata with crop_coords
print("\n=== Updating metadata ===")
metadata_path = output_dir / 'metadata.json'
with open(metadata_path, 'r', encoding='utf-8') as f:
    metadata = json.load(f)

# Add crop_coords to each question
for q in metadata['questions']:
    q_name = f"q-{q['number']:03d}"
    if q_name in crop_coords:
        q['crop_coords'] = crop_coords[q_name]

with open(metadata_path, 'w', encoding='utf-8') as f:
    json.dump(metadata, f, ensure_ascii=False, indent=2)

print(f"Updated {len(crop_coords)} questions with crop_coords")
print("\nDone!")
