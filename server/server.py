from __future__ import division
import re
import sys
import os
from getpass import getpass
from flask import Flask, request, render_template,jsonify
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


app = Flask(__name__)

cred = credentials.Certificate('/home/pi/server/secrets/secret.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

imagesCollection = db.collection('images')
images = imagesCollection.stream()
imageCount = 0
imageUrls = []
for image in images:
    dictionaryImage = image.to_dict()
    imageUrls.append(dictionaryImage['fileLocation'])
    imageCount+=1

@app.route('/')
def home():
    return render_template('home.html', imageCount=imageCount, imageUrls=imageUrls)
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)