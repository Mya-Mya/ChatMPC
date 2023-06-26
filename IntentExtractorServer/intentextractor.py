from abc import ABC, abstractmethod
from classes import Class


class IntentExtractor(ABC):
    """
    Representates Intent Extractor block, a part of Interpreter A.

    Inside the Interpreter A, we have the following block diagram:
    prompt p -> [Intent Extractor] -> Class c -> [Parameter Calculator] -> New Parameter.
    """
    @abstractmethod
    def on_recieve_prompt(self, prompt: str) -> Class:
        """
        Called when receive prompt p from user.

        Parameters
        ----------
        prompt : str
            The prompt p.
        
        Returns
        -------
        c : Class
            The Class enum object that representates Class c. 
        """
        raise NotImplementedError()
