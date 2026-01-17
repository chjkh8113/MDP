"""
Fix Q82 and Q83 - include all options for both.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Extend to include Clk + all 4 options
q82 = img_p20[700:1020, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=700-1020")

# Q83: Start after Q82 options, include Q83's full options
q83 = img_p20[1020:1200, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=1020-1200")

print("\nDone!")
