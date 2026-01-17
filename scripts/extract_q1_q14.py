"""
Extract Q1-Q14 from pages 02-04.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Page 02 - Q1-Q7 (Vocabulary)
img_p02 = cv2.imread('resources/konkur-images/1404/page-02.png')
h02, w02 = img_p02.shape[:2]
print(f"Page 02: {w02}x{h02}")

questions_p02 = [
    (1, 330, 415, "Vocabulary - evolution/forefathers"),
    (2, 415, 495, "Vocabulary - greenhouse effect"),
    (3, 495, 560, "Vocabulary - charitable motives"),
    (4, 560, 630, "Vocabulary - Nigerian intervention"),
    (5, 630, 710, "Vocabulary - idyllic environment"),
    (6, 710, 780, "Vocabulary - Die Hards movie"),
    (7, 780, 860, "Vocabulary - China-Soviet relations"),
]

for q_num, y_start, y_end, topic in questions_p02:
    crop = img_p02[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px) - {topic}")

# Page 03 - Q8-Q12 (Cloze Test + Reading Comprehension)
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')
h03, w03 = img_p03.shape[:2]
print(f"\nPage 03: {w03}x{h03}")

questions_p03 = [
    (8, 180, 250, "Cloze test - to be opened"),
    (9, 250, 310, "Cloze test - that are now part"),
    (10, 310, 395, "Cloze test - Olympic Games"),
    (11, 1050, 1130, "Reading comprehension - utilize meaning"),
    (12, 1130, 1210, "Reading comprehension - them reference"),
]

for q_num, y_start, y_end, topic in questions_p03:
    crop = img_p03[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px) - {topic}")

# Page 04 - Q13-Q14 (Reading Comprehension for Passage 1)
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
h04, w04 = img_p04.shape[:2]
print(f"\nPage 04: {w04}x{h04}")

questions_p04 = [
    (13, 120, 260, "Reading comprehension - paragraph 1"),
    (14, 260, 330, "Reading comprehension - words EXCEPT"),
]

for q_num, y_start, y_end, topic in questions_p04:
    crop = img_p04[y_start:y_end, :]
    filename = f"q-{q_num:03d}.png"
    cv2.imwrite(str(output_dir / filename), crop)
    print(f"  Q{q_num}: y={y_start}-{y_end} ({y_end-y_start}px) - {topic}")

# Also extract Cloze Test passage (for context)
cloze_passage = img_p02[895:1080, :]
cv2.imwrite(str(output_dir / 'passage-cloze.png'), cloze_passage)
print(f"\nCloze passage: y=895-1080 from page-02")

# Continuation on page 03
cloze_passage_cont = img_p03[35:180, :]
cv2.imwrite(str(output_dir / 'passage-cloze-cont.png'), cloze_passage_cont)
print(f"Cloze passage continuation: y=35-180 from page-03")

print(f"\nExtracted Q1-Q14!")
