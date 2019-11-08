# pip install tornado
import tornado.ioloop
import tornado.web

# pip install markdown
import markdown
import os

from markdown.inlinepatterns import InlineProcessor
from markdown.util import etree

# for custom tags like "tab", add "<div class='tab'></div>
# an oversimplified regex
MYPATTERN = r'\*([^*]+)\*'
NEWPATTERN = r'\[!NOTE]'

class EmphasisPattern(InlineProcessor):
    def handleMatch(self, m, data):
        #print ("found match")
        #el = etree.Element('em')
        #el.text = m.group(1)
        print (m.group(0))
        #return el, m.start(0), m.end(0)
        return "subber", m.start(0), m.end(0)

# pass in pattern and create instance
emphasis = EmphasisPattern(NEWPATTERN)

from markdown.extensions import Extension
from markdown.util import etree

class MyExtension(Extension):
    def extendMarkdown(self, md):
        print ("extend")
        # md.registerExtension(self)
        # pass in pattern and create instance
        md.inlinePatterns.register(emphasis, 'mypattern', 175)

class MarkdownHandler(tornado.web.RequestHandler):
    def post(self):
        md = self.get_body_argument("md", default=None)
        form = self.get_body_argument("form", default=None) # comma-delimited array
        self.write(markdown.markdown(md, extensions=[MyExtension()]))

def make_app():
    return tornado.web.Application([
        (r"/markdown", MarkdownHandler),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
