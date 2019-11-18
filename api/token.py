
import pymongo
from bson.json_util import dumps
from bson.objectid import ObjectId

import base64

import os, sys, json
import secrets

import Crypto.Random
from Crypto.Cipher import AES
import hashlib

client = pymongo.MongoClient("mongodb://localhost:27017/")
database = client["tree"]
collection = database["tokens"]

# secure cookies sent from tornado...

def process(token, status, hash):
    #...generate token
    process_token = secrets.token_hex(16)
    
    if status == "initiate":
        collection.insert_one({'client_token':token,'server_token':process_token,'status':status})
    elif status == "authenticate":
        #...client has used token to create/send password hash and token2
        query = {'client_token':token, 'server_token':server_token, 'status':'initiate'}
        result = collection.find(query)

        if result:
            user = hash.user
            password = hash.password
            token = hash.token

            exists_query = {"user":user, "password":password, "client_token":token, "email":"true"}
            result = collection.find(query)

            if result:
                value = { "$set": { "client_token":token, "server_token":process_token, "status":status } }
                collection.update_one(exists_query, value))
            else:
                value = { "$set": { "user":user, "password":password, "client_token":token, "server_token":process_token, "status":status, "email":"false" } }
                collection.update_one(query, value)
                # send email with new server_token...
    elif status == "authorize":
        query = {'client_token':token, 'server_token':server_token, 'status':'authenticate', 'email':'true'}
        result = collection.find(query)

        if result:
            token = hash.token
            value = { "$set": { "client_token":token, "server_token":process_token, "status":status } }
            collection.update_one(query, value))
        else:
            # get email...
            email_query = {'user':email, 'server_token':server_token, 'status':'authenticate', 'email':'false'}
            result = collection.find(email_query)

            value = { "$set": { "server_token":process_token, "email":"true", "status":status } }
            collection.update_one(email_query, value))
    elif status == "accept":
        query = {'client_token':token, 'server_token':server_token, 'status':'accept', 'email':'true'}
        result = collection.find(query)

        if result:
            # check datetime...
            value = { "$set": { "expiration":current} }
            collection.update_one(query, value))
        else:
            newuser_query = {'client_token':token, 'server_token':server_token, 'status':'authorize', 'email':'true'}
            result = collection.find(newuser_query)

            if result:
                value = { "$set": { "client_token":token, "server_token":process_token, "status":status } }
                collection.update_one(query, value))
            else:
            
    
    return temp_token

def post(self): #update user
        email = self.get_body_argument("email", default=None, strip=False)
        password = self.get_body_argument("password", default=None, strip=False)
        query = { "email": email }
        value = { "$set": { "password": password } }
        self.write(dumps(collection.update_one(query, value)))

def createUser:
    start_response('200 OK', [('Content-Type', 'text/html')])

    token_client = decoded[0]
    token_server = token.newToken()
    email = decoded[1]
    password_hash = decoded[2]

    #check if user exists...
    query = {'email':email}
    result = collection.find(query)
    exists = result
    if exists:
        attempts = result['attempts']
        if attempts > 3:
            sendMail(email, 'new_user_attempts')
            return false
        elif
            attempts += 1
            collection.update_one({'email':email},{'$set':{'token_server':token_server, 'token_client':token_client, 'attempts':attempts}})
    elif:
        collection.insert_one({'email':email,'password':password_hash, 'valid':false, 'token_server':token_server, 'token_client':token_client, 'attempts':1})

    sendMail(email, 'new_user', token_server)

    return true

def application(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])

    token_server = decoded[0]
    email = decoded[1]

    #check if user exists...
    query = {'email':email}
    result = collection.find(query)
    exists = result
    if exists:
        if token.updateToken(email, token_server):
            collection.update_one({'email':email},{'$set':{'valid':true}})
    elif:
        #handle suspicious activity...
        collection.insert_one({'email':email,'password':password_hash, 'valid':false, 'token_server':token_server, 'token_client':token_client, 'attempts':1})
token_server = token.newToken()
    sendMail(email, 'new_user', token_server)

    return true

SALT_SIZE = 16
NUMBER_OF_ITERATIONS = 20
AES_MULTIPLE = 16

def generate_key(password, salt, iterations):
    assert iterations > 0

    key = password + salt

    for i in range(iterations):
        key = hashlib.sha256(key).digest()  

    return key

def pad_text(text, multiple):
    extra_bytes = len(text) % multiple
    padding_size = multiple - extra_bytes
    padding = chr(padding_size) * padding_size
    padded_text = text + padding

    return padded_text

def unpad_text(padded_text):
    padding_size = ord(padded_text[-1])
    text = padded_text[:-padding_size]

    return text

def encrypt(plaintext, password):
    salt = Crypto.Random.get_random_bytes(SALT_SIZE)
    key = generate_key(password, salt, NUMBER_OF_ITERATIONS)
    cipher = AES.new(key, AES.MODE_ECB)
    padded_plaintext = pad_text(plaintext, AES_MULTIPLE)
    ciphertext = cipher.encrypt(padded_plaintext)
    ciphertext_with_salt = salt + ciphertext

    return ciphertext_with_salt

def decrypt(ciphertext, password):
    salt = ciphertext[0:SALT_SIZE]
    ciphertext_sans_salt = ciphertext[SALT_SIZE:]
    key = generate_key(password, salt, NUMBER_OF_ITERATIONS)
    cipher = AES.new(key, AES.MODE_ECB)
    padded_plaintext = cipher.decrypt(ciphertext_sans_salt)
    plaintext = unpad_text(padded_plaintext)

    return plaintext