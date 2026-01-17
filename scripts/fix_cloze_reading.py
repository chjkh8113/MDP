"""
Fix Q8-Q12, Q14 with correct boundaries.
The cloze questions (8-10) are AFTER the passage continuation.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Looking at earlier test: Q10's y=360-460 showed Q8-Q9 content
# So Q8 starts around y=360
# Cloze passage continuation is at y=35-225 or so
# Then Q8, Q9, Q10 are the numbered options

q8 = img_p03[360:430, :]
cv2.imwrite(str(output_dir / 'q-008.png'), q8)
print("Q8: y=360-430")

q9 = img_p03[430:500, :]
cv2.imwrite(str(output_dir / 'q-009.png'), q9)
print("Q9: y=430-500")

q10 = img_p03[500:600, :]
cv2.imwrite(str(output_dir / 'q-010.png'), q10)
print("Q10: y=500-600")

# Q11-Q12 are at the bottom after Passage 1
# Looking at earlier test where Q11 showed passage text at y=1090
# Q11 "utilize" question should be further down
q11 = img_p03[1285:1365, :]
cv2.imwrite(str(output_dir / 'q-011.png'), q11)
print("Q11: y=1285-1365")

q12 = img_p03[1365:1445, :]
cv2.imwrite(str(output_dir / 'q-012.png'), q12)
print("Q12: y=1365-1445")

# Q14 - trim Q13's option from top
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
q14 = img_p04[350:420, :]
cv2.imwrite(str(output_dir / 'q-014.png'), q14)
print("Q14: y=350-420")

print("\nFixed!")
