"""
Final fix for Q11-Q12 - include options.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1404')
img_p03 = cv2.imread('resources/konkur-images/1404/page-03.png')

# Q11 - start at question, include all options
q11 = img_p03[1340:1440, :]
cv2.imwrite(str(output_dir / 'q-011.png'), q11)
print("Q11: y=1340-1440")

# Q12 - include question and all options
q12 = img_p03[1440:1550, :]
cv2.imwrite(str(output_dir / 'q-012.png'), q12)
print("Q12: y=1440-1550")

print("\nDone!")
