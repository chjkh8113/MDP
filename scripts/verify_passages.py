import json
with open('resources/konkur-questions/1404/metadata.json', 'r', encoding='utf-8') as f:
    m = json.load(f)
print(f"Passages: {len(m.get('passages', []))}")
for p in m.get('passages', []):
    print(f"  - {p['id']}: {p['title']} ({len(p['linked_questions'])} questions)")
