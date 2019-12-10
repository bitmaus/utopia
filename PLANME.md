
## installation

security checksum

extra packages: imagemagick repo tigervnc rsync hostapd dnsmasq

## dev and entertainment builds

see Inkscape, GIMP, Blender, OpenShot, FreeCAD

use [Godot](https://godotengine.org/)/VLC for game/media streaming with video cards, MiraCast, compete with [Stadia](https://stadia.google.com/home)
...[Vulkan](https://www.khronos.org/) (OpenGL) to support linux FPS, use algorithm to automate drawing?

http://feeds.bbci.co.uk/news/rss.xml

calendar stickers, hour glass, agenda, online/phone booking for automated check-in, email/newsletter, layered budget spreadsheet

That's actually a pretty easy thing to do when using Linux:

Activate the directoryPerDB config option
Create the databases you need.
Shut down the instance.
Copy over the data from the individual database directories to the different block devices (disks, RAID arrays, Logical volumes, iSCSI targets and alike).
Mount the respective block devices to their according positions beyond the dbpath directory (don't forget to add the according lines to /etc/fstab!)
Restart mongod.


create software RAID on linux using mdadm...
https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04

Finally, if you're not constrained to Tornado for some reason, I would highly recommend the requests library (or grequests for asynchronous calls).

EDIT: To serve a static file as a download, do something like this in your handler's get:

def get(self):
    file_name = 'file.ext'
    buf_size = 4096
    self.set_header('Content-Type', 'application/octet-stream')
    self.set_header('Content-Disposition', 'attachment; filename=' + file_name)
    with open(file_name, 'r') as f:
        while True:
            data = f.read(buf_size)
            if not data:
                break
            self.write(data)
    self.finish()

dynamic IP...
Assuming you're happy with trusting the IP in the header of the second request, then yes, you can do it with use-server:

backend bk_foo
  [...]
  server srv_0a_00_01_05 10.0.1.5:80 weight 100
  server srv_0a_00_02_05 10.0.2.5:80 weight 100
  use-server %[req.hdr(x-backend-ip),lower,map_str(/etc/haproxy/hdr2srv.map,srv_any)] if { req.hdr(x-backend-ip),lower,map_str(/etc/haproxy/hdr2srv.map) -m found }
Contents of /etc/haproxy/hdr2srv.map:

#ip srv_name
# hex of IP used for names in this example
10.0.1.5  srv_0a_00_01_05
10.0.2.5  srv_0a_00_02_05
If you need to down one of the servers, you should dynamically update the map to remove it, so that the requests with the header set get redirected again.

If you have multiple backends, you can do similar with use_backend.

https://www.haproxy.com/blog/dynamic-configuration-haproxy-runtime-api/

./xmrig -o pool.minexmr.com:4444 -u 4851piqsk8FSUU267Czcq1HLVzhAwZSma3cifsf6nbEt9w1RXvYxaogEwrNNxC699W64SQfE7zne9H8n1VhrQsnZ7g9U5GF --donate-level=1%%

pacman -S dhcp

# dd if=/dev/zero of=header.img bs=16M count=1
# cryptsetup luksFormat /dev/sdX --offset 32768 --header header.img

cryptsetup open --header header.img /dev/sdX enc

cryptsetup luksHeaderBackup /dev/<device> --header-backup-file /mnt/<backup>/<file>.img
cryptsetup luksHeaderRestore /dev/<device> --header-backup-file ./mnt/<backup>/<file>.img

git clone https://bitmaus:Treeop4714%21@github.com/bitmaus/key.git


<!-- setup YouTube channel programming channel
video tips... no drinking, cover arms, situp straight, no pauses
-->

use reference

db.createCollection("dictionary")