"""
Fix 1403 v3 - extend boundaries.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')

# Page 21 - Q85 with full table (P1 and P2 rows)
img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')
q85 = img_p21[35:530, :]  # Extended more for P2 row and option 4
cv2.imwrite(str(output_dir / 'q-085.png'), q85)
print("Q85: y=35-530")

# Page 24 - push all boundaries down
img_p24 = cv2.imread('resources/konkur-images/1403/page-24.png')

q96 = img_p24[75:420, :]  # Extended
cv2.imwrite(str(output_dir / 'q-096.png'), q96)
print("Q96: y=75-420")

q97 = img_p24[420:680, :]  # Start after Q96 fully
cv2.imwrite(str(output_dir / 'q-097.png'), q97)
print("Q97: y=420-680")

q98 = img_p24[680:830, :]
cv2.imwrite(str(output_dir / 'q-098.png'), q98)
print("Q98: y=680-830")

q99 = img_p24[830:1200, :]
cv2.imwrite(str(output_dir / 'q-099.png'), q99)
print("Q99: y=830-1200")

q100 = img_p24[1200:1380, :]  # Extended for options
cv2.imwrite(str(output_dir / 'q-100.png'), q100)
print("Q100: y=1200-1380")

print("\nDone!")
