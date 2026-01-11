"""
Extract Q81-Q85 from 1403 exam (pages 20-21).
Final working coordinates after visual verification.

Page 20 Questions (Q81-Q84):
- Header ends at y≈140
- Q81: Sequential circuit timing (y=140-700)
- Q82: Shift register + Majority (y=700-1080)
- Q83: Cache memory (y=1080-1262)
- Q84: Floating point representation (y=1262-1540)

Page 21 Question (Q85):
- Header ends at y≈140
- Q85: CPI comparison (y=140-520)
"""

import cv2
from pathlib import Path


def extract_page20_21(output_dir: Path):
    """Extract Q81-Q85 from pages 20-21."""
    output_dir.mkdir(parents=True, exist_ok=True)

    # Page 20: Q81-Q84
    img_p20 = cv2.imread('resources/konkur-images/1403/page-20.png')
    if img_p20 is None:
        raise FileNotFoundError("page-20.png not found")

    boundaries_p20 = {
        'q-081': (140, 700),   # Sequential circuit timing
        'q-082': (700, 1080),  # Shift register + Majority
        'q-083': (1080, 1262), # Cache memory
        'q-084': (1262, 1540), # Floating point representation
    }

    for name, (y_start, y_end) in boundaries_p20.items():
        img = img_p20[y_start:y_end, :]
        cv2.imwrite(str(output_dir / f'{name}.png'), img)
        print(f"{name}: y={y_start}-{y_end} ({img.shape[0]}px)")

    # Page 21: Q85
    img_p21 = cv2.imread('resources/konkur-images/1403/page-21.png')
    if img_p21 is None:
        raise FileNotFoundError("page-21.png not found")

    q85 = img_p21[140:520, :]
    cv2.imwrite(str(output_dir / 'q-085.png'), q85)
    print(f"q-085: y=140-520 ({q85.shape[0]}px)")


if __name__ == '__main__':
    output_dir = Path('resources/konkur-questions/1403')
    extract_page20_21(output_dir)
    print("\nDone! Q81-Q85 extracted.")
