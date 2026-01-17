"""
Fix Q82 - trim Q81's Clk from top, include Q82's full content.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Start at question "82-" text (after Q81's Clk), include full content
q82 = img_p20[680:955, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=680-955")

print("\nDone!")
