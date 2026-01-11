"""
Fix page 20 v2 - cleaner boundaries.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q81: Keep as is (35-620) - it's good

# Q82: Start after Q81 Clk line (~640), extend for full circuit + options
q82 = img_p20[640:950, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=640-950")

# Q83: Start after Q82 options (~950)
q83 = img_p20[950:1160, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=950-1160")

# Q84: Start after Q83 options (~1160)
q84 = img_p20[1160:1600, :]
cv2.imwrite(str(output_dir / 'q-084.png'), q84)
print("Q84: y=1160-1600")

print("\nFixed!")
