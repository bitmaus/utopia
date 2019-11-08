import zipfile, os
 
def create_archive(path):
    '''Create the ZIP archive.  The mimetype must be the first file in the archive 
    and it must not be compressed.'''
 
    epub_name = '%s.epub' % os.path.basename(path)
 
    # The EPUB must contain the META-INF and mimetype files at the root, so 
    # we'll create the archive in the working directory first and move it later
        
 
    # Open a new zipfile for writing
    epub = zipfile.ZipFile(epub_name, 'w')
 
    # Add the mimetype file first and set it to be uncompressed
    
     
    # For the remaining paths in the EPUB, add all of their files
    # using normal ZIP compression
    os.chdir(path)
    epub.write('MIMETYPE', compress_type=zipfile.ZIP_STORED)
    for p in os.listdir('.'):
        print (p)
        
        #epub.write(p, compress_type=zipfile.ZIP_DEFLATED)
        if os.path.isdir(p):
            print (p)
            for f in os.listdir(p):
                print (f)
                if os.path.isdir(os.path.join(p, f)):
                    for g in os.listdir(os.path.join(p, f)):
                        print (g)
                        epub.write(os.path.join(os.path.join(p, f), g), compress_type=zipfile.ZIP_DEFLATED)
                else:
                    epub.write(os.path.join(p, f), compress_type=zipfile.ZIP_DEFLATED)
    epub.close()

create_archive('epub')