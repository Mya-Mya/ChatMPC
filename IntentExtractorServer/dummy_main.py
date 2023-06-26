"""
Launch server with Dummy Intent Extractor.
"""
from server import launch
from dummyintentextractor import DummyIntentExtractor

if __name__ == "__main__":    
    launch(DummyIntentExtractor())
