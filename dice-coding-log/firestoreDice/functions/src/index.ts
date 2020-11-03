import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as firebaseHelper from 'firebase-functions-helper';
import * as express from 'express';
import * as bodyParser from "body-parser";

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();

const app = express();
const main = express();

main.use('/api/v1', app);
main.use(bodyParser.json());
main.use(bodyParser.urlencoded({ extended: false }));


const sideCollection = 'log';
export const webApi = functions.https.onRequest(main);

// Add
app.post('/log', async (req, res) => {
    try {
        const logData = {
            side: req.body['side'],
            timeSpent: req.body['timeSpent'],
            startTime: req.body['startTime'],
        }
const newDoc = await firebaseHelper.firestore
            .createNewDocument(db, sideCollection, logData);
        res.status(201).send(`Created a log: ${newDoc.id}`);
    } catch (error) {
        res.status(400).send('problem')
    }        
})




// Update new contact
app.patch('/battery/:contactId', async (req, res) => {
    const updatedDoc = await firebaseHelper.firestore
        .updateDocument(db, "battery", req.params.contactId, req.body);
    res.status(204).send(`Update a new contact: ${updatedDoc}`);
})
