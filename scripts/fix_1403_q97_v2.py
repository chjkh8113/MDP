"""
Fix Q97 v2 - trim top more, extend bottom for all options.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

# Q97 - trim Q96 option 4, show all 4 Q97 options
q97 = img_p24[520:780, :]
cv2.imwrite(str(output_dir / 'q-097.png'), q97)
print("Q97: y=520-780")

print("\nFixed!")
