from flask import Flask
from flask import jsonify
from flask import request
from flask_cors import CORS

import pickle
import codecs, re, time
from itertools import chain
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.preprocessing import normalize
import numpy as np

app = Flask(__name__)
CORS(app)

@app.route("/analyze", methods = ['POST'])
def analyzeText():
    text = request.args.get('text');
    nn_classifier_pickle_in = open('nn_model.pickle', 'rb')
    vectorizer_pickle_in = open('vectorizer.pickle', 'rb')

    nn_classifier = pickle.load(nn_classifier_pickle_in)
    vectorizer = pickle.load(vectorizer_pickle_in)

    text.lower()

    vectorizer_test = CountVectorizer(stop_words=None, vocabulary = vectorizer.vocabulary_,  input = 'content')
    vector = vectorizer_test.fit_transform([text])
    vector = normalize(vector, norm='l1', axis=1)

    prediction = nn_classifier.predict(vector)
    print('prediction:');
    print(prediction);

    return prediction[0];


if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=8000)
