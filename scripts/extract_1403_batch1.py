"""
Extract 1403 exam Q80-Q100 from pages 19-24.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
output_dir.mkdir(parents=True, exist_ok=True)

# Page 19 - Q80 (Verilog/VHDL - large question)
img_p19 = cv2.imread('resources/konkur-images/1403/page-19.png')
print(f"Page 19: {img_p19.shape}")

q80 = img_p19[35:1580, :]
cv2.imwrite(str(output_dir / 'q-080.png'), q80)
print("Q80: y=35-1580 (Verilog/VHDL)")

# Page 20 - Q81-Q84
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')
print(f"\nPage 20: {img_p20.shape}")

questions_p20 = [
    (81, 35, 435, "Timing diagram, flip-flops"),
    (82, 435, 700, "Shift register, majority"),
    (83, 700, 920, "Cache memory 2-way"),
    (84, 920, 1200, "Floating point representation"),
]

for q_num, y_start, y_end, topic in questions_p20:
    crop = img_p20[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'q-{q_num:03d}.png'), crop)
    print(f"Q{q_num}: y={y_start}-{y_end} - {topic}")

# Page 21 - Q85-Q88
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')
print(f"\nPage 21: {img_p21.shape}")

questions_p21 = [
    (85, 35, 330, "CPI implementations"),
    (86, 330, 530, "ALU speedup"),
    (87, 530, 880, "Subroutine control unit"),
    (88, 880, 1580, "Cache hierarchy"),
]

for q_num, y_start, y_end, topic in questions_p21:
    crop = img_p21[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'q-{q_num:03d}.png'), crop)
    print(f"Q{q_num}: y={y_start}-{y_end} - {topic}")

# Page 22 - Q89-Q92
img_p22 = cv2.imread('resources/konkur-images/1403/page-22.png')
print(f"\nPage 22: {img_p22.shape}")

questions_p22 = [
    (89, 35, 140, "Booth algorithm shifts"),
    (90, 140, 570, "CMOS circuit output"),
    (91, 570, 890, "CMOS power consumption"),
    (92, 890, 1580, "Circuit VOH/VOL"),
]

for q_num, y_start, y_end, topic in questions_p22:
    crop = img_p22[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'q-{q_num:03d}.png'), crop)
    print(f"Q{q_num}: y={y_start}-{y_end} - {topic}")

# Page 23 - Q93-Q95
img_p23 = cv2.imread('resources/konkur-images/1403/page-23.png')
print(f"\nPage 23: {img_p23.shape}")

questions_p23 = [
    (93, 35, 370, "CMOS inverter power"),
    (94, 370, 750, "Transistor Vout"),
    (95, 750, 1200, "Charge sharing"),
]

for q_num, y_start, y_end, topic in questions_p23:
    crop = img_p23[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'q-{q_num:03d}.png'), crop)
    print(f"Q{q_num}: y={y_start}-{y_end} - {topic}")

# Page 24 - Q96-Q100
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')
print(f"\nPage 24: {img_p24.shape}")

questions_p24 = [
    (96, 35, 270, "OS threads"),
    (97, 270, 520, "Round Robin scheduling"),
    (98, 520, 660, "Kernel operations"),
    (99, 660, 1050, "Virtual memory page table"),
    (100, 1050, 1200, "Convoy effect"),
]

for q_num, y_start, y_end, topic in questions_p24:
    crop = img_p24[y_start:y_end, :]
    cv2.imwrite(str(output_dir / f'q-{q_num:03d}.png'), crop)
    print(f"Q{q_num}: y={y_start}-{y_end} - {topic}")

print(f"\nExtracted Q80-Q100 (21 questions)")
