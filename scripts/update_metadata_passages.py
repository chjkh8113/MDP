"""
Update metadata with passage information and question-passage links.
"""

import json
from pathlib import Path

metadata_path = Path('resources/konkur-questions/1404/metadata.json')

with open(metadata_path, 'r', encoding='utf-8') as f:
    metadata = json.load(f)

# Add passages array
metadata['passages'] = [
    {
        "id": "passage-01",
        "filename": "passage-01.png",
        "title": "Computer Ethics",
        "title_fa": "اخلاق کامپیوتر",
        "topic": "computer_ethics",
        "description": "The emergence of computers and ethical concerns including privacy, hackers, and technology ethics",
        "source_page": "page-03",
        "linked_questions": [11, 12, 13, 14, 15],
        "keywords": ["computer ethics", "internet", "privacy", "hackers", "technology", "ethical standards"]
    },
    {
        "id": "passage-02",
        "filename": "passage-02.png",
        "title": "Early Computers and Babbage",
        "title_fa": "کامپیوترهای اولیه و بابیج",
        "topic": "early_computers",
        "description": "History of computing from abacus to Babbage's Difference Engine and Scheutz's machine",
        "source_page": "page-04",
        "linked_questions": [16, 17, 18, 19, 20],
        "keywords": ["abacus", "Babbage", "Difference Engine", "Scheutz", "computer history", "1823", "1853"]
    },
    {
        "id": "passage-03",
        "filename": "passage-03.png",
        "title": "Quantum Computing",
        "title_fa": "محاسبات کوانتومی",
        "topic": "quantum_computing",
        "description": "Shor's algorithm, Landauer's work on quantum computation challenges, qubits, and quantum computer construction",
        "source_page": "page-05",
        "linked_questions": [21, 22, 23, 24, 25],
        "keywords": ["quantum computing", "Shor", "Landauer", "qubits", "quantum gates", "entanglement", "coherence"]
    }
]

# Update questions with related_passage field
passage_map = {
    15: "passage-01",
    16: "passage-02",
    17: "passage-02",
    18: "passage-02",
    19: "passage-02",
    20: "passage-02",
    21: "passage-03",
    22: "passage-03",
    23: "passage-03",
    24: "passage-03",
    25: "passage-03"
}

for q in metadata['questions']:
    q_num = q['number']
    if q_num in passage_map:
        q['related_passage'] = passage_map[q_num]

# Save updated metadata
with open(metadata_path, 'w', encoding='utf-8') as f:
    json.dump(metadata, f, ensure_ascii=False, indent=2)

print(f"Updated metadata with {len(metadata['passages'])} passages")
print(f"Linked questions: {list(passage_map.keys())}")
