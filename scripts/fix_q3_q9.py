"""
Fix Q3-Q9 boundaries - ensure all options visible, no bleed from previous questions.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Page 02 - Q3-Q7
img_p02 = cv2.imread('resources/konkur-images/1404/page-02.png')

# Recalculated boundaries - each question ~90px to include all 4 options
# Q1: 695-785, Q2: 785-870
# Q3 starts after Q2's options
q3 = img_p02[870:965, :]
cv2.imwrite(str(output_dir / 'q-003.png'), q3)
print("Q3: y=870-965 (95px)")

# Q4 starts after Q3's options
q4 = img_p02[965:1055, :]
cv2.imwrite(str(output_dir / 'q-004.png'), q4)
print("Q4: y=965-1055 (90px)")

# Q5 starts after Q4's options
q5 = img_p02[1055:1145, :]
cv2.imwrite(str(output_dir / 'q-005.png'), q5)
print("Q5: y=1055-1145 (90px)")

# Q6 starts after Q5's options
q6 = img_p02[1145:1235, :]
cv2.imwrite(str(output_dir / 'q-006.png'), q6)
print("Q6: y=1145-1235 (90px)")

# Q7 starts after Q6's options
q7 = img_p02[1235:1330, :]
cv2.imwrite(str(output_dir / 'q-007.png'), q7)
print("Q7: y=1235-1330 (95px)")

# Page 03 - Q8-Q9
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Q8-Q10 are cloze test options after the passage
# Need to show question number and all 4 options
q8 = img_p03[350:420, :]
cv2.imwrite(str(output_dir / 'q-008.png'), q8)
print("Q8: y=350-420 (70px)")

q9 = img_p03[420:490, :]
cv2.imwrite(str(output_dir / 'q-009.png'), q9)
print("Q9: y=420-490 (70px)")

print("\nFixed Q3-Q9!")
