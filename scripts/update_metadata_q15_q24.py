import json
from pathlib import Path

metadata_path = Path('resources/konkur-questions/1404/metadata.json')

with open(metadata_path, 'r', encoding='utf-8') as f:
    metadata = json.load(f)

# Enriched metadata for Q15-Q24 (English Reading)
new_questions = [
    {
        'number': 15,
        'filename': 'q-015.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - computer ethics',
        'topic_fa': 'درک مطلب - اخلاق کامپیوتر',
        'subtopics': ['computer ethics', 'hackers', 'privacy', 'technology'],
        'keywords': ['ethics', 'hackers', 'privacy', 'technology', 'true statement'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'computer_ethics',
        'source_page': 'page-04'
    },
    {
        'number': 16,
        'filename': 'q-016.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Vocabulary - word meaning',
        'topic_fa': 'واژگان - معنی کلمه',
        'subtopics': ['vocabulary', 'synonym', 'context clues'],
        'keywords': ['required', 'meaning', 'vocabulary', 'synonym'],
        'question_type': 'vocabulary',
        'target_word': 'required',
        'source_page': 'page-04'
    },
    {
        'number': 17,
        'filename': 'q-017.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - abacus definition',
        'topic_fa': 'درک مطلب - تعریف چرتکه',
        'subtopics': ['abacus', 'ancient computers', 'definition'],
        'keywords': ['abacus', 'invention', 'device', 'ancient'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'early_computers',
        'source_page': 'page-04'
    },
    {
        'number': 18,
        'filename': 'q-018.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - paragraph 1 main idea',
        'topic_fa': 'درک مطلب - ایده اصلی پاراگراف ۱',
        'subtopics': ['main idea', 'Chinese', 'mathematical laws', 'computers'],
        'keywords': ['paragraph 1', 'Chinese', 'mathematical', 'computers'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'computer_history',
        'source_page': 'page-05'
    },
    {
        'number': 19,
        'filename': 'q-019.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - Scheutz Difference Engine',
        'topic_fa': 'درک مطلب - ماشین تفاضل شویتس',
        'subtopics': ['Scheutz', 'Difference Engine', 'Babbage', '1853'],
        'keywords': ['Scheutz', 'Difference Engine', 'Babbage', 'computer history'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'computer_history',
        'source_page': 'page-05'
    },
    {
        'number': 20,
        'filename': 'q-020.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - passage information scope',
        'topic_fa': 'درک مطلب - محدوده اطلاعات متن',
        'subtopics': ['passage scope', 'Mars', 'first computer country', 'older tools'],
        'keywords': ['passage information', 'sufficient', 'Mars', 'first computer'],
        'question_type': 'reading_comprehension',
        'has_sub_questions': True,
        'source_page': 'page-05'
    },
    {
        'number': 21,
        'filename': 'q-021.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - writing techniques',
        'topic_fa': 'درک مطلب - تکنیک‌های نگارش',
        'subtopics': ['writing techniques', 'definition', 'statistics', 'rhetorical'],
        'keywords': ['techniques', 'definition', 'statistics', 'cause effect', 'rhetorical'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'quantum_computing',
        'source_page': 'page-06'
    },
    {
        'number': 22,
        'filename': 'q-022.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - Landauer statements',
        'topic_fa': 'درک مطلب - گزاره‌های لانداور',
        'subtopics': ['Landauer', 'quantum computation', 'challenges'],
        'keywords': ['Landauer', 'quantum', 'computation', 'challenges', 'solutions'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'quantum_computing',
        'source_page': 'page-06'
    },
    {
        'number': 23,
        'filename': 'q-023.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - paragraph 3 main discussion',
        'topic_fa': 'درک مطلب - موضوع اصلی پاراگراف ۳',
        'subtopics': ['main idea', 'quantum computers', 'qubit efficiency'],
        'keywords': ['paragraph 3', 'quantum computers', 'qubit', 'efficiency'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'quantum_computing',
        'source_page': 'page-06'
    },
    {
        'number': 24,
        'filename': 'q-024.png',
        'section': 'English',
        'section_fa': 'زبان انگلیسی',
        'topic': 'Reading comprehension - qubits and quantum computers',
        'topic_fa': 'درک مطلب - کیوبیت و کامپیوترهای کوانتومی',
        'subtopics': ['qubits', 'Shor', 'quantum computers', 'Landauer'],
        'keywords': ['qubits', 'quantum', 'Shor', 'Landauer', 'versatile'],
        'question_type': 'reading_comprehension',
        'passage_topic': 'quantum_computing',
        'source_page': 'page-06'
    },
]

metadata['questions'] = new_questions + metadata['questions']
metadata['total_questions'] = len(metadata['questions'])

with open(metadata_path, 'w', encoding='utf-8') as f:
    json.dump(metadata, f, ensure_ascii=False, indent=2)

print(f"Updated metadata: {metadata['total_questions']} questions (Q15-Q94)")
