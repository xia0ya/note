import spacy
from spacy import displacy
nlp = spacy.load("en_core_web_sm")
doc = nlp("This is a sentence about Google.")
doc.user_data["title"] = "This is a title"
displacy.serve(doc, style="ent",port=8080)