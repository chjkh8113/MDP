"""
Fix 1403 Q80-Q100 boundaries.
Page height is 1685px.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')

# Page 21 - Q85-Q88 (fix boundaries)
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')

q85 = img_p21[35:380, :]  # Include table and options
cv2.imwrite(str(output_dir / 'q-085.png'), q85)
print("Q85: y=35-380")

q86 = img_p21[380:580, :]
cv2.imwrite(str(output_dir / 'q-086.png'), q86)
print("Q86: y=380-580")

q87 = img_p21[580:920, :]
cv2.imwrite(str(output_dir / 'q-087.png'), q87)
print("Q87: y=580-920")

q88 = img_p21[920:1600, :]
cv2.imwrite(str(output_dir / 'q-088.png'), q88)
print("Q88: y=920-1600")

# Page 22 - Q89-Q92
img_p22 = cv2.imread('resources/konkur-images/1403/page-22.png')

q89 = img_p22[35:150, :]
cv2.imwrite(str(output_dir / 'q-089.png'), q89)
print("Q89: y=35-150")

q90 = img_p22[150:600, :]
cv2.imwrite(str(output_dir / 'q-090.png'), q90)
print("Q90: y=150-600")

q91 = img_p22[600:920, :]
cv2.imwrite(str(output_dir / 'q-091.png'), q91)
print("Q91: y=600-920")

q92 = img_p22[920:1600, :]
cv2.imwrite(str(output_dir / 'q-092.png'), q92)
print("Q92: y=920-1600")

# Page 24 - Q96-Q100
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

q96 = img_p24[75:320, :]  # Skip section header
cv2.imwrite(str(output_dir / 'q-096.png'), q96)
print("Q96: y=75-320")

q97 = img_p24[320:570, :]
cv2.imwrite(str(output_dir / 'q-097.png'), q97)
print("Q97: y=320-570")

q98 = img_p24[570:720, :]
cv2.imwrite(str(output_dir / 'q-098.png'), q98)
print("Q98: y=570-720")

q99 = img_p24[720:1100, :]
cv2.imwrite(str(output_dir / 'q-099.png'), q99)
print("Q99: y=720-1100")

q100 = img_p24[1100:1250, :]
cv2.imwrite(str(output_dir / 'q-100.png'), q100)
print("Q100: y=1100-1250")

print("\nFixed!")
