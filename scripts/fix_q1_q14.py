"""
Fix specific Q1-Q14 boundary issues.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Page 02 fixes
img_p02 = cv2.imread('resources/konkur-images/1404/page-02.png')

# Q4 - remove Q3's options from top
q4 = img_p02[965:1050, :]
cv2.imwrite(str(output_dir / 'q-004.png'), q4)
print("Q4: y=965-1050")

# Q7 - remove Q6's options, extend bottom for options
q7 = img_p02[1200:1300, :]
cv2.imwrite(str(output_dir / 'q-007.png'), q7)
print("Q7: y=1200-1300")

# Page 03 fixes
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Q8-Q10 are cloze test questions - they're just the options after the passage
# Looking at page structure: passage ends ~225, then Q8 options, Q9, Q10
q8 = img_p03[225, 295, :]  # Just Q8 options
q8 = img_p03[225:295, :]
cv2.imwrite(str(output_dir / 'q-008.png'), q8)
print("Q8: y=225-295")

q9 = img_p03[295:360, :]
cv2.imwrite(str(output_dir / 'q-009.png'), q9)
print("Q9: y=295-360")

q10 = img_p03[360:470, :]
cv2.imwrite(str(output_dir / 'q-010.png'), q10)
print("Q10: y=360-470")

# Q11 - should be at ~1095 where question starts, not passage
q11 = img_p03[1095:1175, :]
cv2.imwrite(str(output_dir / 'q-011.png'), q11)
print("Q11: y=1095-1175")

# Q12
q12 = img_p03[1175:1255, :]
cv2.imwrite(str(output_dir / 'q-012.png'), q12)
print("Q12: y=1175-1255")

# Page 04 fixes
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')

# Q13 - extend to include all 4 options
q13 = img_p04[155:320, :]
cv2.imwrite(str(output_dir / 'q-013.png'), q13)
print("Q13: y=155-320")

# Q14 - start after Q13, include options
q14 = img_p04[320:420, :]
cv2.imwrite(str(output_dir / 'q-014.png'), q14)
print("Q14: y=320-420")

print("\nFixed Q4, Q7-Q14!")
