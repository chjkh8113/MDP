"""
Fix Q82 and Q83 - ensure complete with all options.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Full question with circuit + Clk + all 4 options
q82 = img_p20[640:960, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=640-960")

# Q83: Full question with all options (16و11, 15و12, etc.)
q83 = img_p20[960:1170, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=960-1170")

print("\nFixed!")
