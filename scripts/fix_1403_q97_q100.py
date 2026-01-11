"""
Fix Q97 and Q100 - trim previous question bleed from top.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

# Q97 - start after Q96 options end
q97 = img_p24[480:700, :]
cv2.imwrite(str(output_dir / 'q-097.png'), q97)
print("Q97: y=480-700")

# Q100 - start after Q99 options end
q100 = img_p24[1260:1400, :]
cv2.imwrite(str(output_dir / 'q-100.png'), q100)
print("Q100: y=1260-1400")

print("\nFixed!")
