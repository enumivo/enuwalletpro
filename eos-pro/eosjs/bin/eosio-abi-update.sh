set -o errexit
set -o xtrace

function process() {
  docker cp docker_nodeosd_1:/contracts/${1}/${1}.abi .
  node ./eosio-abi-update.js $1 $2
  mv ./$2 ../src/schema
}

process enu.token eosio_token.json
process enu.system eosio_system.json
