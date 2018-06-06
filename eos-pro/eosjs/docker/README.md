Dockerized enumivo instance for development and testing.  This container
is designed to reset its blockchain and wallet state upon shutdown.

# Start nodeosd

Starting and stopping an enumivo instance:

```js
./up.sh
docker-compose down
```

# Load commands like `cleos`

```bash
. ./dockrc.sh
```

# Unit Test

Run all unit test in a temporary instance.  Note, this script will run
`npm install` in the eosjs directory.

`./run_tests.sh`

# Running container

After ./up.sh

```bash
docker exec docker_nodeosd_1 ls /opt/enumivo/bin
docker exec docker_nodeosd_1 ls /contracts
docker cp docker_nodeosd_1:/opt/enumivo/bin/nodeos .

# Or setup an environment:
. ./dockerc.sh
keosd ls /opt/enumivo/bin
cleos --help
```

# Stopped container

```bash
# Note, update release
docker run --rm -it enumivo/eos:latest ls /opt/enumivo/bin
docker run -v "$(pwd):/share" --rm -it enumivo/eos:latest cp /opt/enumivo/bin/nodeos /share
```

