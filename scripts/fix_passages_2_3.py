"""
Fix Passages 2 and 3 - trim question content from top.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# PASSAGE 2 from page-04 - start after Q15's options
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
# Q15 options end around y=595, "PASSAGE 2:" header at ~600
passage2 = img_p04[595:1105, :]
cv2.imwrite(str(output_dir / 'passage-02.png'), passage2)
print(f"PASSAGE 2: y=595-1105 (510px)")

# PASSAGE 3 from page-05 - start after Q20
img_p05 = cv2.imread('resources/konkur-images/1404/page-05.png')
# Q20 ends around y=595, "PASSAGE 3:" header at ~600
passage3 = img_p05[595:1650, :]
cv2.imwrite(str(output_dir / 'passage-03.png'), passage3)
print(f"PASSAGE 3: y=595-1650 (1055px)")

print("\nPassages 2 & 3 fixed!")
