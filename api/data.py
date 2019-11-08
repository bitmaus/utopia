
import ast

# pip install tornado
import tornado.ioloop
import tornado.web

# pip install pymongo
import pymongo

from bson.objectid import ObjectId
from bson.json_util import dumps

import token

port = 4444
client = pymongo.MongoClient("mongodb://localhost:27017/")

class DataHandler(tornado.web.RequestHandler):
    def post(self):
        user = self.get_body_argument("user", default=None, strip=False)
        token = self.get_body_argument("token", default=None, strip=False)
        items = self.get_body_argument("collection", default=None, strip=False)
        action = self.get_body_argument("action", default=None, strip=False)
        query = self.get_body_argument("query", default=None, strip=False)
        value = self.get_body_argument("value", default=None, strip=False)

        print(user)
        print(items)

        database = client[user]
        collection = database[items]

        if action == "select":
            self.write(dumps(collection.find(ast.literal_eval(query))))
        elif action == "insert":
            collection.insert_one(ast.literal_eval(query))
        elif action == "update":
            collection.update_one({"_id": ObjectId(value)}, ast.literal_eval(query))
        elif action == "delete":
            collection.delete_one({"_id": ObjectId(value)})

def make_app():
    return tornado.web.Application([
        (r"/data", DataHandler),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(port)
    tornado.ioloop.IOLoop.current().start()
