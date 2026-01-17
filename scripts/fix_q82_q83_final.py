"""
Fix Q82 and Q83 - precise extraction.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Start at question number (skip Q81 Clk), include full circuit + options
q82 = img_p20[650:955, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=650-955")

# Q83: Include full question with all options
q83 = img_p20[955:1180, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=955-1180")

print("\nDone!")
