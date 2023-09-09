## ChatMPC

## Reproduce the Numerical Experiment

### 1. Download Sentence BERT Pre-trained Weights
Sentence BERT model is used in the intent extractor $f_\mathrm{int}$ in the interpreter $\mathcal{A}$. In the numerical experiment, we used `deepset/sentence_bert` as the pre-trained weights. 

Clone it from the [HuggingFace Model page](https://huggingface.co/deepset/sentence_bert).

### 2. Launch the IntentExtractor Python Server
Most of ChatMPC is implemented in MATLAB, but only the intent extractor $f_\mathrm{int}$ is implemented in Python. MATLAB code and the Python code communicate via HTTP.

Recall the path to the Sentence BERT folder, and execute the following:
```bash
>> cd IntentExtractor
>> python3 main.py --sbert_path <path to the Sentence BERT folder>
```
Check that the server is running on `http://127.0.0.1:3838`.

### 3. Work in MATLAB
The code for the numerical experiment is `main.m`. 

Please run it **SECTION BY SECTION** because I'll need you to run the commands yourself in the middle of running.