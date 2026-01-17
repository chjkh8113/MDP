"""
Fix Q10 - extend top for option 1.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Extend top to capture full option 1
q10 = img_p03[470:575, :]
cv2.imwrite(str(output_dir / 'q-010.png'), q10)
print("Q10: y=470-575 (105px)")
