import pyconll
import os

def preprocess_ontonotes(ontonotes_dir):
    conll_data = []

    for root, dirs, files in os.walk(ontonotes_dir):
        for file in files:
            if file.endswith(".name") or file.endswith(".parse"):
                filepath = os.path.join(root, file)
                conll_data += pyconll.load_from_file(filepath)

    return conll_data

def convert_to_conll(conll_data):
    conll_sentences = []

    for conll in conll_data:
        conll_sentences.append(conll.to_conll())

    return "\n".join(conll_sentences)


ontonotes_dir = "Data/ontonotes-release-5.0/"
conll_data = preprocess_ontonotes(ontonotes_dir)
converted_data = convert_to_conll(conll_data)

output_file = "Data/ontonotes-conll/file.conll"

with open(output_file, "w", encoding="utf-8") as file:
    file.write(converted_data)
