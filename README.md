**INSTALL**

* Clone this repository : `git clone https://github.com/heimdall-watch/heimdall_docker`
* (Optional) Modify the docker-compose.yml environment variables according to your expected configuration

**Development environment**
* Execute command `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up` from the root of the heimdall_docker folder
* You can now access the web interface at `http://localhost`

**Production environment**
* Execute command `docker-compose up` from the root of the heimdall_docker folder

Now that the environment is installed, you can start/stop/restart it with: `docker-compose start` (replacing start by the desired action)

**Access the container**

You can access the container as root with `docker exec -ti heimdall_web /bin/bash`

Use `docker exec -ti -u heimdall heimdall_web /bin/bash` to use the heimdall user instead of root (to run composer for example, which should never be ran as root)