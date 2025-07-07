import spacy
from spacy import displacy
from spacy.tokens import Span

text = "Welcome to the Bank of China."

nlp = spacy.load("en_core_web_sm")
doc = nlp(text)

doc.spans["sc"] = [
    Span(doc, 3, 6, "ORG"),
    Span(doc, 5, 6, "GPE"),
]

displacy.serve(doc, style="span",port=8080)