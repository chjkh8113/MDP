"""
Fix page 20 boundaries - Q81-Q84.
"""

import cv2
from pathlib import Path

output_dir = Path('resources/konkur-questions/1403')
img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')

# Q81: Full question with complete circuit (extend to 620)
q81 = img_p20[35:620, :]
cv2.imwrite(str(output_dir / 'q-081.png'), q81)
print("Q81: y=35-620")

# Q82: Start after Q81's circuit, include Majority circuit + options
q82 = img_p20[620:920, :]
cv2.imwrite(str(output_dir / 'q-082.png'), q82)
print("Q82: y=620-920")

# Q83: Cache question (after Q82's options)
q83 = img_p20[920:1130, :]
cv2.imwrite(str(output_dir / 'q-083.png'), q83)
print("Q83: y=920-1130")

# Q84: Floating point (rest of page)
q84 = img_p20[1130:1600, :]
cv2.imwrite(str(output_dir / 'q-084.png'), q84)
print("Q84: y=1130-1600")

print("\nFixed page 20!")
