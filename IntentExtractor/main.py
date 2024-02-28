from enum import Enum
from typing import Literal
from pathlib import Path
from argparse import ArgumentParser
from sentence_transformers import SentenceTransformer
from sklearn.neighbors import KNeighborsClassifier
from flask import Flask, request
import json

# --------------------------------
# Class & Update Marker Definition
# --------------------------------

class Class(Enum):
    SV = "SV"  # Separate from Vase
    AV = "AV"  # Approach to Vase
    ST = "ST"  # Separate from Toy
    AT = "AT"  # Approach to Toy


CLASS_S = [Class.SV, Class.AV, Class.ST, Class.AT]
CLASS_TO_LABEL = {c: l for l, c in enumerate(CLASS_S)}
CLASS_TO_UPDATE_MARKER = {
    Class.SV: [-1, 0],
    Class.AV: [+1, 0],
    Class.ST: [0, -1],
    Class.AT: [0, +1]
}


# -------------
# Train Samples
# -------------

def create_train_sample_s_for_label(
    label: int,
    direction: Literal["approach to", "separate from"],
    obstacletype: Literal["vase", "toy"]
):
    sentence_s = [
        f"Can you {direction} the {obstacletype}?",
        f"Please {direction} the {obstacletype}.",
    ]
    if direction == "approach to":
        sentence_s += [
            f"You do not need to care about the {obstacletype}.",
            f"You do not need to be careful about the {obstacletype}.",
            f"You do not have to care about the {obstacletype} so much."
        ]
    if direction == "separate from":
        sentence_s += [
            f"It is too close to the {obstacletype}.",
            f"Too close to the {obstacletype}.",
            f"You are too closing to the {obstacletype}"
        ]
    label_s = [label]*len(sentence_s)
    return sentence_s, label_s


SV_TRAIN_SAMPLE_S = create_train_sample_s_for_label(
    CLASS_TO_LABEL[Class.SV], "separate from", "vase")
AV_TRAIN_SAMPLE_S = create_train_sample_s_for_label(
    CLASS_TO_LABEL[Class.AV], "approach to", "vase")
ST_TRAIN_SAMPLE_S = create_train_sample_s_for_label(
    CLASS_TO_LABEL[Class.ST], "separate from", "toy")
AT_TRAIN_SAMPLE_S = create_train_sample_s_for_label(
    CLASS_TO_LABEL[Class.AT], "approach to", "toy")

TRAIN_SENTENCE_S = \
    SV_TRAIN_SAMPLE_S[0]+AV_TRAIN_SAMPLE_S[0] +\
    ST_TRAIN_SAMPLE_S[0]+AT_TRAIN_SAMPLE_S[0]
TRAIN_LABEL_S = \
    SV_TRAIN_SAMPLE_S[1]+AV_TRAIN_SAMPLE_S[1] +\
    ST_TRAIN_SAMPLE_S[1]+AT_TRAIN_SAMPLE_S[1]

#if __name__ == "__main__":
# -----------------------------
# Launching Sentence BERT Model
# -----------------------------

parser = ArgumentParser()
parser.add_argument("--sbert_path", type=Path, required=True,
                    help="Path to the Sentence BERT model.")
args = parser.parse_args()
sbert_path = args.sbert_path
sentencebert = SentenceTransformer(str(sbert_path))


# -----------------------------
# Training Classification Model
# -----------------------------

train_embedding_s = sentencebert.encode(TRAIN_SENTENCE_S)
classifier = KNeighborsClassifier()
classifier.fit(train_embedding_s, TRAIN_LABEL_S)


# ----------------
# Launching Server
# ----------------

server = Flask(__name__)

@server.post("/")
def get_():
    # -------------------------------------------
    # Core Implementation of the Intent Extractor
    # -------------------------------------------
    prompt = request.get_data(as_text=True)
    embedding = sentencebert.encode(prompt)

    classifier_output = classifier.predict([embedding])
    pred_label = classifier_output[0]
    pred_class = CLASS_S[pred_label]
    update_marker = CLASS_TO_UPDATE_MARKER[pred_class]

    response = json.dumps(update_marker)
    return response, 200

server.run(host="0.0.0.0", port=3838, debug=False)
