"""
Launch Paper Intent Extractor and test it.
"""
from server import launch
from paperintentextractor import PaperIntentExtractor
from argparse import ArgumentParser
from pathlib import Path

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--lm_path", type=Path, required=True, help="Path to the Sentence BERT model.")
    args = parser.parse_args()
    lm_path = args.lm_path

    e = PaperIntentExtractor(lm_path)

    prompt = input("Prompt :")
    while not prompt=="exit":
        c = e.on_recieve_prompt(prompt)
        print("Class :",c.name)
        prompt = input("Prompt :")