
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
collection = database["token"]
        
def post(self):
        # token system
        email = self.get_body_argument("email", default=None, strip=False)
        query = { "email": email }
        self.write(dumps(collection.find(query)))

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

def application(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    parsed = parse_qs(environ['QUERY_STRING'])
    status = parsed['status'][0]
    #secure cookie with status (initiate) and id (random1)
    #...client uses random1 to create/send password hash and random2
    if status == "initiate":
        temp_token = secrets.token_hex(16)
        res.set_cookie('status', 'initiate', max_age=360, path='/', domain='treeop.com', secure=True)
        res.set_cookie('token', temp_token, max_age=360, path='/', domain='treeop.com', secure=True)
        collection.insert_one({'token':temp_token,'status':'initiate'})
    elif status == "authenticate":
        #server validates/stores password hash with status (authenticate) and id (random3) *uses random1 and random2
        #...client validates and encrypts/sends email/sensitive information and random4
        hash = parsed['hash'][0]
        client_token = parsed['token'][0]
        query = {'email':email}
        result = collection.find(query)
        old_token =

        temp_token = secrets.token_hex(16)
        res.set_cookie('status', 'authenticate', max_age=360, path='/', domain='treeop.com', secure=True)
        res.set_cookie('token', temp_token, max_age=360, path='/', domain='treeop.com', secure=True)
    elif status == "authorize":
        #server validates/stores information with status (success) and server token (with expiration)
        #...client validates and stores/sends client token
        temp_token = secrets.token_hex(16)
        res.set_cookie('status', 'authorize', max_age=360, path='/', domain='treeop.com', secure=True)
        res.set_cookie('token', temp_token, max_age=360, path='/', domain='treeop.com', secure=True)
    elif status == "accept":
        temp_token = secrets.token_hex(16)
        res.set_cookie('status', 'accept', max_age=360, path='/', domain='treeop.com', secure=True)
        res.set_cookie('token', temp_token, max_age=360, path='/', domain='treeop.com', secure=True)

def decrypt(ciphertext, password):
    salt = ciphertext[0:SALT_SIZE]
    ciphertext_sans_salt = ciphertext[SALT_SIZE:]
    key = generate_key(password, salt, NUMBER_OF_ITERATIONS)
    cipher = AES.new(key, AES.MODE_ECB)
    padded_plaintext = cipher.decrypt(ciphertext_sans_salt)
    plaintext = unpad_text(padded_plaintext)

    return plaintext

def cookies:
    handler = {}
    if 'HTTP_COOKIE' in os.environ:
        cookies = os.environ['HTTP_COOKIE']
        cookies = cookies.split('; ')

        for cookie in cookies:
            cookie = cookie.split('=')
            handler[cookie[0]] = cookie[1]

    for k in handler:
        print k + " = " + handler[k] + "<br>
        print ("select")
        result="["
        for doc in collection.find():
            result+=dumps(doc)
            result+=","
        result+="]"
        return [result]

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
