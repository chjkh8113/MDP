"""
Extract passages with precise boundaries - just header + text.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# PASSAGE 1 from page-03 (Computer Ethics)
# Start at "PASSAGE 1:" header (y~635), end before Q11 (y~1050)
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')
passage1 = img_p03[630:1050, :]
cv2.imwrite(str(output_dir / 'passage-01.png'), passage1)
print(f"PASSAGE 1 (Computer Ethics): y=630-1050 (420px)")

# PASSAGE 2 from page-04 (Early Computers / Babbage)
# Start at "PASSAGE 2:" header (y~535), end before Q16 (y~1105)
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
passage2 = img_p04[530:1105, :]
cv2.imwrite(str(output_dir / 'passage-02.png'), passage2)
print(f"PASSAGE 2 (Early Computers): y=530-1105 (575px)")

# PASSAGE 3 from page-05 (Quantum Computing)
# Start at "PASSAGE 3:" header (y~540), go to end of passage (~1650)
img_p05 = cv2.imread('resources/konkur-images/1404/page-05.png')
passage3 = img_p05[530:1650, :]
cv2.imwrite(str(output_dir / 'passage-03.png'), passage3)
print(f"PASSAGE 3 (Quantum Computing): y=530-1650 (1120px)")

print("\nPassages extracted!")
