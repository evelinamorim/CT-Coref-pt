import math
import json
from utils import flatten_list_of_lists

import random

random.seed(42)

def read_data(file_path):

    docs_len = {}
    total_words = 0
    with open(file_path, 'r') as f:

        for line in f:

            d = json.loads(line.strip())
            doc_key = d["doc_key"]
            input_words = flatten_list_of_lists(d["sentences"])
            prefix_doc = doc_key.split(".")[0]

            if prefix_doc in docs_len:
                docs_len[prefix_doc] += len(input_words)
            else:
                docs_len[prefix_doc] = len(input_words)

            total_words += len(input_words)

    train_split = math.floor(0.8 * total_words)
    docs_len = list(docs_len.items())
    random.shuffle(docs_len)

    # prepare the training split
    train_split_docs = []
    train_split_len = 0

    for (doc, doc_len) in docs_len:

        if train_split_len + doc_len <= train_split:
            train_split_docs.append(doc)
            train_split_len += doc_len
        else:
            break

    return train_split_docs
def write_data(file_path, train_split, output_file):

    fd_train = open(output_file + "_train.jsonlines","w")
    fd_test = open(output_file + "_test.jsonlines","w")

    with open(file_path, 'r') as f:
        for line in f:
            d = json.loads(line.strip())
            doc_key = d["doc_key"]
            data = json.dumps(d)
            if doc_key.split(".")[0] in train_split:
                fd_train.write(data + "\n")
            else:
                fd_test.write(data + "\n")

    fd_train.close()
    fd_test.close()

if __name__ == "__main__":
    train_split = read_data("Data/Corref-PT-v1.4/JSON/Corref-PT-SemEval_noseg.jsonlines")
    write_data("Data/Corref-PT-v1.4/JSON/Corref-PT-SemEval_noseg.jsonlines", train_split, "Data/Corref-PT-v1.4/JSON/Corref-PT-SemEval_noseg")
