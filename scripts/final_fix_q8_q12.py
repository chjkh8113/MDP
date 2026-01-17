"""
Final fix for Q8-Q12 on page-03.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Cloze test Q8-Q10 - these are option lists after the passage
# Based on test: y=360-430 shows Q8 with Q9 bleeding in
# Need more precise boundaries

# Q8 - just the Q8 line
q8 = img_p03[360:400, :]
cv2.imwrite(str(output_dir / 'q-008.png'), q8)
print("Q8: y=360-400")

# Q9 - Q9 line
q9 = img_p03[400:450, :]
cv2.imwrite(str(output_dir / 'q-009.png'), q9)
print("Q9: y=400-450")

# Q10 - Q10 line with all options
q10 = img_p03[450:550, :]
cv2.imwrite(str(output_dir / 'q-010.png'), q10)
print("Q10: y=450-550")

# Q11 and Q12 are at the BOTTOM of page-03 after Passage 1
# Passage 1 ends around y=1050, then Q11 at ~1095
q11 = img_p03[1095:1170, :]
cv2.imwrite(str(output_dir / 'q-011.png'), q11)
print("Q11: y=1095-1170")

q12 = img_p03[1170:1250, :]
cv2.imwrite(str(output_dir / 'q-012.png'), q12)
print("Q12: y=1170-1250")

print("\nDone!")
