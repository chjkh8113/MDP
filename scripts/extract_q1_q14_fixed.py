"""
Extract Q1-Q14 with corrected boundaries.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Page 02 - Q1-Q7 (Vocabulary)
# Looking at the page: Persian form ends ~265, PART A header ~290, Directions ~315
# Q1 starts at ~375
img_p02 = cv2.imread('resources/konkur-images/1404/page-02.png')
print(f"Page 02 dimensions: {img_p02.shape}")

questions_p02 = [
    (1, 375, 465, "Vocabulary - evolution/forefathers"),
    (2, 465, 545, "Vocabulary - greenhouse effect"),
    (3, 545, 615, "Vocabulary - charitable motives"),
    (4, 615, 695, "Vocabulary - Nigerian intervention"),
    (5, 695, 780, "Vocabulary - idyllic environment"),
    (6, 780, 855, "Vocabulary - Die Hards movie"),
    (7, 855, 940, "Vocabulary - China-Soviet relations"),
]

for q_num, y_start, y_end, topic in questions_p02:
    crop = img_p02[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px)")

# Page 03 - Q8-Q12
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')
print(f"\nPage 03 dimensions: {img_p03.shape}")

# Cloze passage continues at top, then Q8-10 (fill-in blanks)
# Q8 options at ~230, Q9 at ~290, Q10 at ~350
# Then PART C at ~480, Passage 1 text, Q11 at ~1095, Q12 at ~1165
questions_p03 = [
    (8, 225, 290, "Cloze test - to be opened"),
    (9, 290, 355, "Cloze test - that are now part"),
    (10, 355, 450, "Cloze test - Olympic Games"),
    (11, 1095, 1170, "Reading - utilize meaning"),
    (12, 1170, 1245, "Reading - them reference"),
]

for q_num, y_start, y_end, topic in questions_p03:
    crop = img_p03[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px)")

# Page 04 - Q13-Q14
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
print(f"\nPage 04 dimensions: {img_p04.shape}")

# Q13 starts at ~160 (after header), Q14 at ~305
questions_p04 = [
    (13, 160, 305, "Reading - paragraph 1 computer technology"),
    (14, 305, 380, "Reading - words EXCEPT"),
]

for q_num, y_start, y_end, topic in questions_p04:
    crop = img_p04[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px)")

print(f"\nExtracted Q1-Q14!")
