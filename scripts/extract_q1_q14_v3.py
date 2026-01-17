"""
Extract Q1-Q14 with properly calculated boundaries.
Based on observation: Q5's old position (y=695) shows Q1 content.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Page 02 - Q1-Q7 (Vocabulary)
# Q1 actually starts around y=695 based on previous test
img_p02 = cv2.imread('resources/konkur-images/1404/page-02.png')

questions_p02 = [
    (1, 695, 785, "Vocabulary - evolution/forefathers"),
    (2, 785, 870, "Vocabulary - greenhouse effect"),
    (3, 870, 940, "Vocabulary - charitable motives"),
    (4, 940, 1015, "Vocabulary - Nigerian intervention"),
    (5, 1015, 1100, "Vocabulary - idyllic environment"),
    (6, 1100, 1175, "Vocabulary - Die Hards movie"),
    (7, 1175, 1260, "Vocabulary - China-Soviet relations"),
]

print("Page 02 - Q1-Q7:")
for q_num, y_start, y_end, topic in questions_p02:
    crop = img_p02[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px)")

# Page 03 - Q8-Q12
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Cloze passage at top, Q8-Q10 fill-in options
# Q11-Q12 are after Passage 1
questions_p03 = [
    (8, 220, 295, "Cloze test - to be opened"),
    (9, 295, 360, "Cloze test - that are now part"),
    (10, 360, 460, "Cloze test - Olympic Games"),
    (11, 1090, 1170, "Reading - utilize meaning"),
    (12, 1170, 1250, "Reading - them reference"),
]

print("\nPage 03 - Q8-Q12:")
for q_num, y_start, y_end, topic in questions_p03:
    crop = img_p03[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px)")

# Page 04 - Q13-Q14
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')

questions_p04 = [
    (13, 155, 310, "Reading - paragraph 1"),
    (14, 310, 390, "Reading - words EXCEPT"),
]

print("\nPage 04 - Q13-Q14:")
for q_num, y_start, y_end, topic in questions_p04:
    crop = img_p04[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px)")

print("\nExtracted Q1-Q14!")
