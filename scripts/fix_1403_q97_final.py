"""
Fix Q97 - clean top, include all options.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

# Q97 - start after Q96 option 4, include all Q97 options
q97 = img_p24[500:730, :]
cv2.imwrite(str(output_dir / 'q-097.png'), q97)
print("Q97: y=500-730")

print("\nFixed!")
