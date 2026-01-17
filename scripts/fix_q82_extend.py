"""
Fix Q82 - extend to include Clk and options.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Extended to include Clk and all options
q82 = img_p20[700:970, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=700-970")

print("\nDone!")
