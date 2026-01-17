"""
Fix Q82 - full extension for Clk and options.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Full question including Clk line and all 4 options
q82 = img_p20[700:1000, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=700-1000 (300px)")

# Also fix Q83 to start after Q82
q83 = img_p20[1000:1200, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=1000-1200 (200px)")

print("\nDone!")
