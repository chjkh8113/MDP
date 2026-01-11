"""
Fix 1403 boundaries v2 - more precise.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')

# Page 21 - Q85 needs full table and options
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')

q85 = img_p21[35:430, :]  # Extended for table
cv2.imwrite(str(output_dir / 'q-085.png'), q85)
print("Q85: y=35-430")

# Page 22 - Q90 starts after Q89
img_p22 = cv2.imread('resources/konkur-images/1403/page-22.png')

q90 = img_p22[165:620, :]  # Start after Q89 options
cv2.imwrite(str(output_dir / 'q-090.png'), q90)
print("Q90: y=165-620")

# Page 24 - fix all
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

q96 = img_p24[75:350, :]  # Full Q96 with options
cv2.imwrite(str(output_dir / 'q-096.png'), q96)
print("Q96: y=75-350")

q97 = img_p24[350:600, :]  # Start after Q96
cv2.imwrite(str(output_dir / 'q-097.png'), q97)
print("Q97: y=350-600")

q98 = img_p24[600:750, :]
cv2.imwrite(str(output_dir / 'q-098.png'), q98)
print("Q98: y=600-750")

q99 = img_p24[750:1120, :]
cv2.imwrite(str(output_dir / 'q-099.png'), q99)
print("Q99: y=750-1120")

q100 = img_p24[1120:1280, :]  # Full Q100 with options
cv2.imwrite(str(output_dir / 'q-100.png'), q100)
print("Q100: y=1120-1280")

print("\nFixed v2!")
