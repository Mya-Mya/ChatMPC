from classes import Class
from intentextractor import IntentExtractor

classname_to_class = {c.name: c for c in (
    Class.AL, Class.SL, Class.AR, Class.SR
)}
classname_s = list(classname_to_class.keys())


class DummyIntentExtractor(IntentExtractor):
    """
    This Intent Extractor does not classify the prompt automatically, but you need to do by hand.
    Useful for development, or debugging purposes.
    """
    def on_recieve_prompt(self, prompt: str) -> Class:
        print(
            "This is Dummy Intent Extractor. Now, Received prompt:'" +
            prompt +
            "'. Which class do you choose?"
        )
        while True:
            inputed = input(
                "Class name(" +
                (",".join(classname_s)) +
                "):"
            )
            if inputed in classname_to_class:
                return classname_to_class[inputed]
            else:
                print("Try again.")
