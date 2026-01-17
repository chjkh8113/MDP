"""
Extract passages with cleaner boundaries.
Include section header + passage text only.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# PASSAGE 1 from page-03 (Computer Ethics)
# Include "PART C: Reading Comprehension" header + Directions + Passage 1
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')
# Start at section header (~380), end before Q11 (~1050)
passage1 = img_p03[380:1050, :]
cv2.imwrite(str(output_dir / 'passage-01.png'), passage1)
print(f"PASSAGE 1 (Computer Ethics): y=380-1050 (670px)")

# PASSAGE 2 from page-04 (Early Computers / Babbage)
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
# Start at "PASSAGE 2:" header (~535), end before Q16 (~1105)
passage2 = img_p04[535:1105, :]
cv2.imwrite(str(output_dir / 'passage-02.png'), passage2)
print(f"PASSAGE 2 (Early Computers): y=535-1105 (570px)")

# PASSAGE 3 from page-05 (Quantum Computing)
img_p05 = cv2.imread('resources/konkur-images/1404/page-05.png')
# Start at "PASSAGE 3:" header (~535), go to end of page content (~1650)
passage3 = img_p05[535:1650, :]
cv2.imwrite(str(output_dir / 'passage-03.png'), passage3)
print(f"PASSAGE 3 (Quantum Computing): y=535-1650 (1115px)")

print("\nPassages extracted!")
