"""
Fix Q6 - extend top for full header, trim bottom to remove Q7.
Fix Q10 - ensure clean boundaries.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')

# Page 02 - Q6
img_p02 = cv2.imread('resources/konkur-images/1404/page-02.png')
# Extend top to capture full "6- While the movie..."
# Trim bottom to not show Q7
q6 = img_p02[1130:1215, :]
cv2.imwrite(str(output_dir / 'q-006.png'), q6)
print("Q6: y=1130-1215 (85px)")

# Page 03 - Q10 - clean up boundaries
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')
q10 = img_p03[480:575, :]
cv2.imwrite(str(output_dir / 'q-010.png'), q10)
print("Q10: y=480-575 (95px)")

print("\nFixed!")
