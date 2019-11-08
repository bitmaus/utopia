import os
import tornado.ioloop
import tornado.web
import markdown

import data
import token

port = 8888

class HomeHandler(tornado.web.RequestHandler):
    def get(self):
        print(self.request.host) # self.request.protocol + "://" + self.request.host + self.request.uri 
        if self.request.host == 'treeop.com:8888':
            self.render('../apt/tree/index.htm')
        elif self.request.host == 'bitma.us:8888':
            self.render('../apt/bit/index.htm')
        elif self.request.host == 'mekanistic.com:8888':
            self.render('../apt/mek/index.htm')

class MdHandler(tornado.web.RequestHandler):
    def post(self):
        md = self.get_body_argument("md", default=None, strip=False)
        response = markdown.markdown(md) 
        self.write(response)

class UserHandler(tornado.web.RequestHandler):
    def post(self):
        status = self.get_secure_cookie("status")

        if status == 'initiate':
            user = self.get_body_argument("user", default=None, strip=False)
            password = self.get_body_argument("password", default=None, strip=False)
            self.set_secure_cookie("mycookie", "myvalue")
            self.write("Your cookie was not set yet!")
        else:
            self.write("Your cookie was set!")

application = tornado.web.Application([
    (r'/', HomeHandler),
    (r'/md', MdHandler),
    (r'/app/(.*)', tornado.web.StaticFileHandler, {'path': '../app'}),
    (r'/bit/(.*)', tornado.web.StaticFileHandler, {'path': '../apt/bit'}),
    (r'/tree/(.*\..*)', tornado.web.StaticFileHandler, {'path': '../apt/tree'}),
    (r'/mek/(.*)', tornado.web.StaticFileHandler, {'path': '../apt/mek'}),

    (r'/user', UserHandler),
])

if __name__ == '__main__':
    application.listen(port)
    tornado.ioloop.IOLoop.instance().start()
