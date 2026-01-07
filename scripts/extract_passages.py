"""
Extract passages and fix Q15 boundary.
"""

import cv2
import json
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Fix Q15 - remove Q14's options from top (was y=380, now y=420)
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
q15_fixed = img_p04[420:680, :]
cv2.imwrite(str(output_dir / 'q-015.png'), q15_fixed)
print(f"Fixed Q15: y=420-680 (260px)")

# Extract PASSAGE 1 from page-03 (Computer Ethics)
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')
# Passage starts after "PASSAGE 1:" header at ~445, ends before Q11 at ~1050
passage1 = img_p03[445:1050, :]
cv2.imwrite(str(output_dir / 'passage-01.png'), passage1)
print(f"Extracted PASSAGE 1 (Computer Ethics): y=445-1050 (605px)")

# Extract PASSAGE 2 from page-04 (Early Computers / Abacus / Babbage)
# Passage starts after "PASSAGE 2:" header at ~540, ends before Q16 at ~1110
passage2 = img_p04[540:1110, :]
cv2.imwrite(str(output_dir / 'passage-02.png'), passage2)
print(f"Extracted PASSAGE 2 (Early Computers): y=540-1110 (570px)")

# Extract PASSAGE 3 from page-05 (Quantum Computing)
img_p05 = cv2.imread('resources/konkur-images/1404/page-05.png')
# Passage starts after "PASSAGE 3:" header at ~540, goes to bottom ~1650
passage3 = img_p05[540:1650, :]
cv2.imwrite(str(output_dir / 'passage-03.png'), passage3)
print(f"Extracted PASSAGE 3 (Quantum Computing): y=540-1650 (1110px)")

print("\nAll passages extracted successfully!")
