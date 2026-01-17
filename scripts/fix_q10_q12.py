"""
Fix Q10-Q12 - need to find exact positions.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Q10 - trim Q9's options from top, ensure all Q10 options visible
q10 = img_p03[475:580, :]
cv2.imwrite(str(output_dir / 'q-010.png'), q10)
print("Q10: y=475-580")

# Q11, Q12 - Passage 1 ends around y=1280
# Then Q11 should start immediately after
q11 = img_p03[1310:1395, :]
cv2.imwrite(str(output_dir / 'q-011.png'), q11)
print("Q11: y=1310-1395")

q12 = img_p03[1395:1480, :]
cv2.imwrite(str(output_dir / 'q-012.png'), q12)
print("Q12: y=1395-1480")

print("\nDone!")
