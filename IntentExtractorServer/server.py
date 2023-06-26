from flask import Flask, request
from classes import Class
from intentextractor import IntentExtractor


def launch(e: IntentExtractor):
    """
    Host server that serves Intent Extractor service.
    
    To send prompt, make a post request with encoded prompt data.
    The response text will be the class name, AL, SL, AR or SR.

    Parameters
    ----------
    e : IntentExtractor
        An implementation of IntentExtractor.
    """

    app = Flask(__name__)
    @app.post("/")
    def get_():
        prompt = request.get_data(as_text=True)
        c = e.on_recieve_prompt(prompt)
        classname = c.name
        return classname, 200
    app.run("0.0.0.0", 3838, debug=False)
