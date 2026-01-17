"""
Fix Q82 final - extend to include full circuit with Clk and options.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Include question text + circuit + Clk line + all options
# Start right after Q81 (620), go until options end (~960)
q82 = img_p20[620:960, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=620-960 (340px)")

# Q83: Start after Q82 options
q83 = img_p20[960:1180, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=960-1180 (220px)")

print("\nFixed!")
