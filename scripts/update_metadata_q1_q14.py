"""
Update metadata with Q1-Q14 information.
"""

import json
from pathlib import Path

metadata_path = Path('resources/konkur-questions/1404/metadata.json')

with open(metadata_path, 'r', encoding='utf-8') as f:
    metadata = json.load(f)

# Q1-Q14 metadata
new_questions = [
    {"number": 1, "filename": "q-001.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Vocabulary - evolution selected", "topic_fa": "واژگان - انتخاب تکاملی",
     "question_type": "vocabulary", "source_page": "page-02"},
    {"number": 2, "filename": "q-002.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Vocabulary - greenhouse effect", "topic_fa": "واژگان - اثر گلخانه‌ای",
     "question_type": "vocabulary", "source_page": "page-02"},
    {"number": 3, "filename": "q-003.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Vocabulary - charitable motives", "topic_fa": "واژگان - انگیزه‌های خیرخواهانه",
     "question_type": "vocabulary", "source_page": "page-02"},
    {"number": 4, "filename": "q-004.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Vocabulary - Nigerian intervention", "topic_fa": "واژگان - مداخله نیجریه",
     "question_type": "vocabulary", "source_page": "page-02"},
    {"number": 5, "filename": "q-005.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Vocabulary - idyllic environment", "topic_fa": "واژگان - محیط آرمانی",
     "question_type": "vocabulary", "source_page": "page-02"},
    {"number": 6, "filename": "q-006.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Vocabulary - Die Hards movie", "topic_fa": "واژگان - فیلم دای هارد",
     "question_type": "vocabulary", "source_page": "page-02"},
    {"number": 7, "filename": "q-007.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Vocabulary - China-Soviet relations", "topic_fa": "واژگان - روابط چین-شوروی",
     "question_type": "vocabulary", "source_page": "page-02"},
    {"number": 8, "filename": "q-008.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Cloze test - Olympic Games", "topic_fa": "آزمون کلوز - بازی‌های المپیک",
     "question_type": "cloze", "related_passage": "passage-cloze", "source_page": "page-03"},
    {"number": 9, "filename": "q-009.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Cloze test - Olympic Games", "topic_fa": "آزمون کلوز - بازی‌های المپیک",
     "question_type": "cloze", "related_passage": "passage-cloze", "source_page": "page-03"},
    {"number": 10, "filename": "q-010.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Cloze test - Olympic Games", "topic_fa": "آزمون کلوز - بازی‌های المپیک",
     "question_type": "cloze", "related_passage": "passage-cloze", "source_page": "page-03"},
    {"number": 11, "filename": "q-011.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Reading - utilize meaning", "topic_fa": "درک مطلب - معنی utilize",
     "question_type": "vocabulary", "related_passage": "passage-01", "source_page": "page-03"},
    {"number": 12, "filename": "q-012.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Reading - them reference", "topic_fa": "درک مطلب - ارجاع them",
     "question_type": "reference", "related_passage": "passage-01", "source_page": "page-03"},
    {"number": 13, "filename": "q-013.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Reading - paragraph 1 computer technology", "topic_fa": "درک مطلب - پاراگراف ۱",
     "question_type": "reading_comprehension", "related_passage": "passage-01", "source_page": "page-04"},
    {"number": 14, "filename": "q-014.png", "section": "English", "section_fa": "زبان انگلیسی",
     "topic": "Reading - words mentioned EXCEPT", "topic_fa": "درک مطلب - کلمات به جز",
     "question_type": "reading_comprehension", "related_passage": "passage-01", "source_page": "page-04"},
]

# Add cloze passage to passages list
cloze_passage = {
    "id": "passage-cloze",
    "filename": "passage-cloze.png",
    "title": "Olympic Games History",
    "title_fa": "تاریخچه بازی‌های المپیک",
    "topic": "olympic_games",
    "description": "History of Olympic Games from ancient times to modern professional era",
    "source_page": "page-02",
    "linked_questions": [8, 9, 10],
    "keywords": ["Olympic Games", "professional athletes", "amateur", "sports"]
}
metadata['passages'].append(cloze_passage)

# Update passage-01 linked_questions to include Q11-Q14
for p in metadata['passages']:
    if p['id'] == 'passage-01':
        p['linked_questions'] = [11, 12, 13, 14, 15]

# Add Q1-Q14 to questions list (prepend)
metadata['questions'] = new_questions + metadata['questions']
metadata['total_questions'] = len(metadata['questions'])

with open(metadata_path, 'w', encoding='utf-8') as f:
    json.dump(metadata, f, ensure_ascii=False, indent=2)

print(f"Updated metadata: {metadata['total_questions']} questions total")
print(f"Passages: {len(metadata['passages'])}")
