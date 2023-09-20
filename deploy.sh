#!/bin/sh

### https://gohugo.io/hosting-and-deployment/deployment-with-rsync/
### Make sure ~/.ssh/config is setup (host1).
USER=my-user
HOST=my-server.com
SSH_HOST=host1
DIR=blog/   # the directory where your web site files should go

# hugo && rsync -avz --delete public/ ${USER}@${HOST}:~/${DIR} # this will delete everything on the server that's not in the local public folder 
hugo && rsync -avz --delete public/ ${SSH_HOST}:~/${DIR} # this will delete everything on the server that's not in the local public folder 

exit 0
