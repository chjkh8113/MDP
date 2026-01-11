"""
Fix page 20 v3 - precise boundaries.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q82: Skip Q81's Clk (start at ~660), include full circuit + Clk + options
q82 = img_p20[660:970, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=660-970")

# Q83: Start after Q82's options (~970)
q83 = img_p20[970:1180, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=970-1180")

# Q84: Start after Q83 (~1180)
q84 = img_p20[1180:1600, :]
cv2.imwrite(str(output_dir / 'q-084.png'), q84)
print("Q84: y=1180-1600")

print("\nFixed!")
