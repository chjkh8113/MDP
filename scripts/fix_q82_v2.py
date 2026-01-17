"""
Fix Q82 v2 - start after Q81's Clk completely.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Start well after Q81's Clk
q82 = img_p20[700:955, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=700-955")

print("\nDone!")
