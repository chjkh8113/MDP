"""
Fix Q7 and Q9 - extend top to include question number.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Page 02 - Q7
img_p02 = cv2.imread('resources/konkur-images/1404/page-02.png')
# Extend top to show "7-" question number
q7 = img_p02[1215:1330, :]
cv2.imwrite(str(output_dir / 'q-007.png'), q7)
print("Q7: y=1215-1330 (115px)")

# Page 03 - Q9
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')
# Extend top to show "9-" question number
q9 = img_p03[405:480, :]
cv2.imwrite(str(output_dir / 'q-009.png'), q9)
print("Q9: y=405-480 (75px)")

print("\nFixed Q7 and Q9!")
