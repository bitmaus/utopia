import tornado.ioloop
import tornado.options
import tornado.web
import tornado.httpserver

from tornado.options import options, define
define("port", default=8888, help="run on the given port", type=int)

class Appliaction(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", HomeHandler),
            (r"/upload", UploadHandler),
        ]
        settings = dict(
            debug = True,
        )
        super(Appliaction, self).__init__(handlers, **settings)

class HomeHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('form.html')

MAX_STREAMED_SIZE = 1024 * 1024 * 1024

@tornado.web.stream_request_body
class UploadHandler(tornado.web.RequestHandler):
    def initialize(self):
        self.bytes_read = 0
        self.data = b''


    def prepare(self):
        self.request.connection.set_max_body_size(MAX_STREAMED_SIZE)

    def data_received(self, chunck):
        self.bytes_read += len(chunck)
        self.data += chunck

    def post(self):
        this_request = self.request
        value = self.data
        with open('file', 'wb') as f:
            f.write(value)


def Main():
    tornado.options.parse_command_line()
    http_server = tornado.httpserver.HTTPServer(Appliaction())
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__":
    Main()

# using...

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload</title>
</head>
<body>
    <h1>Upload</h1>
    <form action="/upload" method="post" enctype="multipart/form-data">
        <input type="file" name="file" id="file" />
        <br />
        <input type="submit" value="upload" />
    </form>
</body>
</html>

# for downloads...
Headers are not sent as soon as you call set_header(); they are not sent until you call flush() or finish() (among other things, this is what makes it possible to replace the output with an error page if an exception is raised before the call to flush())

Even if you call flush(), the entire server is blocked during the call to urlopen(). This is a blocking call which must be replaced with an asynchronous version in Tornado (see the user's guide for more on this). Tornado provides an asynchronous HTTP client which can be used in place of urlopen():

@gen.coroutine
def get(self):
    url = self.get_argument('url')
    filename = self.get_argument('filename')
    self.set_header('Content-Type', 'application/octet-stream')
    self.set_header('Content-Disposition', 'attachment; filename=%s' % filename)

    self.flush()
    response = yield AsyncHTTPClient().fetch(url)
    self.finish(response.body)
This process loads the entire remote file into memory at once, and doesn't send any of it to the browser until the whole thing has been read from the remote server. If the file is large, you may wish to read it in chunks and send them back to the client as they are read:

# inside get() as above, after self.flush():
def streaming_callback(chunk):
    self.write(chunk)
    self.flush()
yield AsyncHTTPClient().fetch(url, streaming_callback=streaming_callback)
self.finish()

# or use...

import os.path
from mimetypes import guess_type

import tornado.web
import tornado.httpserver

BASEDIR_NAME = os.path.dirname(__file__)
BASEDIR_PATH = os.path.abspath(BASEDIR_NAME)

FILES_ROOT = os.path.join(BASEDIR_PATH, 'files')


class FileHandler(tornado.web.RequestHandler):

    def get(self, path):
        file_location = os.path.join(FILES_ROOT, path)
        if not os.path.isfile(file_location):
            raise tornado.web.HTTPError(status_code=404)
        content_type, _ = guess_type(file_location)
        self.add_header('Content-Type', content_type)
        with open(file_location) as source_file:
            self.write(source_file.read())

app = tornado.web.Application([
    tornado.web.url(r"/(.+)", FileHandler),
])

http_server = tornado.httpserver.HTTPServer(app)
http_server.listen(8080, address='localhost')
tornado.ioloop.IOLoop.instance().start()

import time
from concurrent.futures import ProcessPoolExecutor
from tornado.ioloop import IOLoop
from tornado import gen

def f(a, b, c, blah=None):
    print "got %s %s %s and %s" % (a, b, c, blah)
    time.sleep(5)
    return "hey there"

@gen.coroutine
def test_it():
    pool = ProcessPoolExecutor(max_workers=1)
    fut = pool.submit(f, 1, 2, 3, blah="ok")  # This returns a concurrent.futures.Future
    print("running it asynchronously")
    ret = yield fut
    print("it returned %s" % ret)
    pool.shutdown()

IOLoop.instance().run_sync(test_it)

for SSl...
ssl_ctx = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
ssl_ctx.load_cert_chain(os.path.join(data_dir, "mydomain.crt"),
                        os.path.join(data_dir, "mydomain.key"))
HTTPServer(application, ssl_options=ssl_ctx)

The @asynchronous decorator should be used to mark a method that is already asynchronous; it does not make the method asynchronous. This post method is synchronous because it does everything it is going to do before returning control to the IOLoop. You need to make the upload() method asynchronous (which generally means it will either take a callback argument or return a Future) and then call it without blocking from post() (I recommend using the @gen.coroutine decorator and calling slow operations by yielding the Futures they return).

your best bet is to do the writes from a thread pool.  concurrent.futures.ThreadPoolExcecutor can be used directly from a Tornado coroutine.

file server...
import tornado.ioloop
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def post(self):
        for k, (info,) in self.request.files.items():
            name, content_type = info['filename'], info['content_type']
            body = info['body']
            print('%s: %s %s %d bytes' % (k, name, content_type, len(body)))

        self.write('OK')


def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])


if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
    
...also uses...
import mimetypes
from functools import partial
from uuid import uuid4

from tornado import gen, httpclient, ioloop


@gen.coroutine
def body_producer(boundary, filenames, write):
    boundary_bytes = boundary.encode()

    for filename in filenames:
        filename_bytes = filename.encode()
        write(b'--%s\r\n' % (boundary_bytes,))
        write(b'Content-Disposition: form-data; name="%s"; filename="%s"\r\n' %
              (filename_bytes, filename_bytes))

        mtype = mimetypes.guess_type(filename)[0] or 'application/octet-stream'
        write(b'Content-Type: %s\r\n' % (mtype.encode(),))
        write(b'\r\n')
        with open(filename, 'rb') as f:
            while True:
                # 16k at a time.
                chunk = f.read(16 * 1024)
                if not chunk:
                    break
                write(chunk)

                # Let the IOLoop process its event queue.
                yield gen.moment

        write(b'\r\n')
        yield gen.moment

    write(b'--%s--\r\n' % (boundary_bytes,))


@gen.coroutine
def post(client, url, filenames):
    boundary = uuid4().hex
    headers = {'Content-Type': 'multipart/form-data; boundary=%s' % boundary}
    producer = partial(body_producer, boundary, filenames)
    response = yield client.fetch(url,
                                  method='POST',
                                  headers=headers,
                                  body_producer=producer)

    print(response)


ioloop.IOLoop.current().run_sync(lambda: post(httpclient.AsyncHTTPClient(),
                                              'http://localhost:8888/',
                                              ('foo.txt', 'bar')))
                                              
...other methods...

import os 
import io 
from concurrent.futures import ThreadPoolExecutor 
from PIL import Image 

class UploadHandler(web.RequestHandler): 
    executor = ThreadPoolExecutor(max_workers=os.cpu_count()) 

    @gen.coroutine 
    def post(self): 
        file = self.request.files['file'][0] 
        try: 
            thumbnail = yield self.make_thumbnail(file.body) 
        except OSError: 
            raise web.HTTPError(400, 'Cannot identify image file') 
        orig_id, thumb_id = yield [ 
            gridfs.put(file.body, content_type=file.content_type), 
            gridfs.put(thumbnail, content_type='image/png')] 
        yield db.imgs.save({'orig': orig_id, 'thumb': thumb_id}) 
        self.redirect('') 

    @run_on_executor 
    def make_thumbnail(self, content): 
        im = Image.open(io.BytesIO(content)) 
        im.convert('RGB') 
        im.thumbnail((128, 128), Image.ANTIALIAS) 
        with io.BytesIO() as output: 
            im.save(output, 'PNG') 
            return output.getvalue()
            
            
...or...
# Change this ...
async def my_func():
    await something

# To this...
@tornado.gen.coroutine
def my_func():
    yield something
    
...and...
# Change this ...
async def my_func():
    await something

# To this...
@tornado.gen.coroutine
def my_func():
    yield something
...and...
from tornado import web, iostream, gen

class DownloadHandler(web.RequestHandler):
    async def get(self, filename):

        ...
        try:
            self.write(chunk)
            await self.flush()
        except iostream.StreamClosedError:
            break
        finally:
            del chunk
            # pause the coroutine so other handlers can run
            await gen.sleep(0.000000001) # 1 nanosecond