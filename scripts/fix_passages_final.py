"""
Final fix for Passages 2 and 3 - start at PASSAGE header only.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# PASSAGE 2 from page-04 - start at "PASSAGE 2:" header (~670)
img_p04 = cv2.imread('resources/konkur-images/1404/page-04.png')
passage2 = img_p04[665:1105, :]
cv2.imwrite(str(output_dir / 'passage-02.png'), passage2)
print(f"PASSAGE 2: y=665-1105 (440px)")

# PASSAGE 3 from page-05 - start at "PASSAGE 3:" header (~660)
img_p05 = cv2.imread('resources/konkur-images/1404/page-05.png')
passage3 = img_p05[660:1650, :]
cv2.imwrite(str(output_dir / 'passage-03.png'), passage3)
print(f"PASSAGE 3: y=660-1650 (990px)")

print("\nPassages fixed!")
