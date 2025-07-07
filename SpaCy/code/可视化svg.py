import spacy
from spacy import displacy
from pathlib import Path

nlp = spacy.load("en_core_web_sm")
sentences = ["This is an example.", "This is another one."]
for sent in sentences:
    doc = nlp(sent)
    svg = displacy.render(doc, style="dep", jupyter=False)
    file_name = '-'.join([w.text for w in doc if not w.is_punct]) + ".svg"
    output_path = Path("./images/" + file_name)
    output_path.open("w", encoding="utf-8").write(svg)