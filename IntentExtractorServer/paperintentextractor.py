from intentextractor import IntentExtractor
from classes import Class
from sentence_transformers import SentenceTransformer
from sklearn.neighbors import KNeighborsClassifier
from typing import Literal, List, Dict, Tuple
from pathlib import Path

CLASSID_TO_CLASS = {
    0: Class.AL,
    1: Class.SL,
    2: Class.AR,
    3: Class.SR
}
CLASS_TO_CLASSID = {c: classid for classid, c in CLASSID_TO_CLASS.items()}


def create_dataset(
        commandid_to_prompts: Dict[Class, List[str]]
) -> Tuple[List[str], List[int]]:
    prompt_s = []
    commandid_s = []
    for c, prompt_s_commandid in commandid_to_prompts.items():
        prompt_s += prompt_s_commandid
        commandid_s += [CLASS_TO_CLASSID[c]] * len(prompt_s_commandid)
    return prompt_s, commandid_s


def generate_train_prompts(
        direction: Literal["approach to", "separate from"],
        objectname: Literal["left", "right"]
) -> List[str]:
    too_status = {
        "approach to": "too far away from",
        "separate from": "too close to"
    }[direction]
    return [
        f"{direction} the {objectname}.",
        f"{direction} the {objectname} stuff.",
        f"{direction} the {objectname} object.",
        f"It is {too_status} the {objectname}.",
        f"{too_status} the {objectname} stuff.",
        f"{too_status} the {objectname} object.",
        f"It's OK to {direction} the {objectname}.",
        f"We can {direction} the {objectname}.",
        f"You can {direction} the {objectname}.",
        f"You must {direction} the {objectname}.",
        f"Please {direction} the {objectname}.",
        f"Can you {direction} the {objectname}?"
    ]


class PaperIntentExtractor(IntentExtractor):
    """
    An implementation of Intent Extractor with the same structure as in our paper.
    """

    def __init__(self, modelpath: Path) -> None:
        super().__init__()
        modelname = str(modelpath)
        self.model = SentenceTransformer(modelname)

        train_ds = create_dataset({
            Class.AL: generate_train_prompts("approach to", "left"),
            Class.SL: generate_train_prompts("separate from", "left"),
            Class.AR: generate_train_prompts("approach to", "right"),
            Class.SR: generate_train_prompts("separate from", "right")
        })
        train_po_s = self.model.encode(train_ds[0])

        self.classifier = KNeighborsClassifier(4)
        self.classifier.fit(train_po_s, train_ds[1])

    def on_recieve_prompt(self, prompt: str) -> Class:
        po = self.model.encode(prompt)
        classifier_output = self.classifier.predict([po])
        pred_classid = classifier_output[0]
        return CLASSID_TO_CLASS[pred_classid]
