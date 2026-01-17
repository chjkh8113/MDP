"""
Re-extract 1403 batch 1 with correct boundaries.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')

# Page 19 - Q80 (trim header)
img_p19 = cv2.imread('resources/konkur-images/1403/page-19.png')
q80 = img_p19[55:1600, :]  # Trim page header
cv2.imwrite(str(output_dir / 'q-080.png'), q80)
print("Q80: y=55-1600 (Verilog/VHDL)")

# Page 20 - Q81-Q84
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q81: includes question + circuit diagram + options (ends at ~560)
q81 = img_p20[35:560, :]
cv2.imwrite(str(output_dir / 'q-081.png'), q81)
print("Q81: y=35-560 (Timing, flip-flops with circuit)")

# Q82: shift register + majority circuit (y=560-870)
q82 = img_p20[560:870, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=560-870 (Shift register, Majority)")

# Q83: cache memory (y=870-1080)
q83 = img_p20[870:1080, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=870-1080 (Cache 2-way)")

# Q84: floating point with table (y=1080-1600)
q84 = img_p20[1080:1600, :]
cv2.imwrite(str(output_dir / 'q-084.png'), q84)
print("Q84: y=1080-1600 (Floating point)")

# Page 21 - Q85-Q88
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')

q85 = img_p21[35:380, :]
cv2.imwrite(str(output_dir / 'q-085.png'), q85)
print("Q85: y=35-380 (CPI)")

q86 = img_p21[380:580, :]
cv2.imwrite(str(output_dir / 'q-086.png'), q86)
print("Q86: y=380-580 (ALU speedup)")

q87 = img_p21[580:920, :]
cv2.imwrite(str(output_dir / 'q-087.png'), q87)
print("Q87: y=580-920 (Subroutine)")

q88 = img_p21[920:1600, :]
cv2.imwrite(str(output_dir / 'q-088.png'), q88)
print("Q88: y=920-1600 (Cache hierarchy)")

# Page 22 - Q89-Q92
img_p22 = cv2.imread('resources/konkur-images/1403/page-22.png')

q89 = img_p22[35:165, :]
cv2.imwrite(str(output_dir / 'q-089.png'), q89)
print("Q89: y=35-165 (Booth)")

q90 = img_p22[165:620, :]
cv2.imwrite(str(output_dir / 'q-090.png'), q90)
print("Q90: y=165-620 (CMOS output)")

q91 = img_p22[620:920, :]
cv2.imwrite(str(output_dir / 'q-091.png'), q91)
print("Q91: y=620-920 (CMOS power)")

q92 = img_p22[920:1600, :]
cv2.imwrite(str(output_dir / 'q-092.png'), q92)
print("Q92: y=920-1600 (VOH/VOL)")

# Page 23 - Q93-Q95
img_p23 = cv2.imread('resources/konkur-images/1403/page-23.png')

q93 = img_p23[35:400, :]
cv2.imwrite(str(output_dir / 'q-093.png'), q93)
print("Q93: y=35-400 (CMOS inverter)")

q94 = img_p23[400:800, :]
cv2.imwrite(str(output_dir / 'q-094.png'), q94)
print("Q94: y=400-800 (Transistor Vout)")

q95 = img_p23[800:1250, :]
cv2.imwrite(str(output_dir / 'q-095.png'), q95)
print("Q95: y=800-1250 (Charge sharing)")

# Page 24 - Q96-Q100
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

q96 = img_p24[75:420, :]
cv2.imwrite(str(output_dir / 'q-096.png'), q96)
print("Q96: y=75-420 (Threads)")

q97 = img_p24[520:780, :]
cv2.imwrite(str(output_dir / 'q-097.png'), q97)
print("Q97: y=520-780 (Round Robin)")

q98 = img_p24[780:920, :]
cv2.imwrite(str(output_dir / 'q-098.png'), q98)
print("Q98: y=780-920 (Kernel)")

q99 = img_p24[920:1200, :]
cv2.imwrite(str(output_dir / 'q-099.png'), q99)
print("Q99: y=920-1200 (Virtual memory)")

q100 = img_p24[1260:1400, :]
cv2.imwrite(str(output_dir / 'q-100.png'), q100)
print("Q100: y=1260-1400 (Convoy effect)")

print("\nRe-extracted all Q80-Q100!")
