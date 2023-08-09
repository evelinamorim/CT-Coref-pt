import re
from pathlib import Path

START_DOC_PATTERN = re.compile(
    #r'#begin document \((.+?)\)(?:; part (\d+))?.*' + '\n')
    r'#begin document (.*?)' + '\n')

END_DOC_STRING = '#end document\n'

from collections import OrderedDict

def read_file(fpath, sep=None, ignore_double_indices=False,
        ignore_comments=True):
    """Read a conll file and return dictionary of documents.

    Dictionary format:
        { name: sentences }

    where `sentences` is a list of sentences,
    * each being a list of tokens,
    * each being a list of annotation (conll cell).
        [
            # a sentence
            [
                # a token
                [docname, index, pos, ..., coref],
                # another token
                [docname, index, pos, ..., coref],
                ...
            ],
            # another sentence
            [
                # a token
                [docname, index, pos, ..., coref],
                # another token
                [docname, index, pos, ..., coref],
                ...
            ],
        ]
    """

    docs = OrderedDict()
    for i, line in enumerate(open(fpath), start=1):
        m = START_DOC_PATTERN.fullmatch(line)
        # new document
        if m:
            key = m.group(1)
            sentences = [] # [ [ tokens... ], [ tokens... ] ]
            new_sentence = True
        elif line == END_DOC_STRING:
            docs[key] = sentences
        elif line == "\n":
            new_sentence = True
        elif line.startswith("#") and ignore_comments:
            pass
        else:
            if new_sentence:
                sentences.append([])
            new_sentence = False
            split = line[:-1].split(sep)
            if isinstance(ignore_double_indices, int) and \
                    ignore_double_indices >= 0 and "-" in split[ignore_double_indices]:
                continue
            sentences[-1].append(split)
    return docs


def split_lines(sents):

    block_lst = []

    block = []
    current_block_len = 0

    for sent in sents:

        if current_block_len + len(sent) > 200:
            block_lst.append(block)

            block = [sent]
            current_block_len = len(sent)
        else:
            block.append(sent)
            current_block_len += len(sent)


    if block != []:
        block_lst.append(block)
    return block_lst

def add_to_output(fd, doc_key, doc):

    fd.write("#begin document %s\n" % doc_key)
    for sents in doc:
        for sent in sents:
            text_line = "\t".join(sent) + "\n"
            fd.write(text_line)
        fd.write("\n")
    fd.write("#end document\n" )


def split_doc(doc_lst, output_file):

    with open(output_file, "w") as fd:
        for k in doc_lst:
            tok_count = sum([len(sent) for sent in doc_lst[k]])
            if tok_count > 200:

                block_lst = split_lines(doc_lst[k])
                count_block = 0
                while block_lst != []:

                    block = block_lst.pop(0)

                    doc_key = Path(k).stem + Path(k).suffix + "; part " + str(count_block)
                    add_to_output(fd, doc_key, block)
                    count_block += 1
            else:
                add_to_output(fd, k, doc_lst[k])

if __name__ == "__main__":
    doc_lst = read_file("Data/Corref-PT-v1.4/SemEval/Corref-PT-SemEval.v4_gold_conll", sep="\t")
    split_doc(doc_lst, "Corref-PT-SemEval.v4_gold_conll.out")
