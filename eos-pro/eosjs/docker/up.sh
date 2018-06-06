#!/usr/bin/env bash
set -o errexit
set -o xtrace

. ./dockrc.sh

# Reset the volumes
docker-compose down

# Update docker
#docker-compose pull

# Start the server for testing
docker-compose up -d
docker-compose logs -f | egrep -v 'Produced block 0' &
sleep 2

cleos wallet create

# Create accounts must happen before eosio.system is installed

# Test accounts (for eosjs)
cleos create account eosio inita $owner_pubkey $active_pubkey
cleos create account eosio initb $owner_pubkey $active_pubkey
cleos create account eosio initc $owner_pubkey $active_pubkey

# System accounts for Nodeosd
cleos create account eosio eosio.bpay $owner_pubkey $active_pubkey
cleos create account eosio eosio.msig $owner_pubkey $active_pubkey
cleos create account eosio eosio.names $owner_pubkey $active_pubkey
cleos create account eosio eosio.ram $owner_pubkey $active_pubkey
cleos create account eosio eosio.ramfee $owner_pubkey $active_pubkey
cleos create account eosio eosio.saving $owner_pubkey $active_pubkey
cleos create account eosio eosio.stake $owner_pubkey $active_pubkey
cleos create account eosio enu.token $owner_pubkey $active_pubkey
cleos create account eosio eosio.vpay $owner_pubkey $active_pubkey

# Deploy, create and issue SYS token to enu.token
# cleos create account eosio enu.token $owner_pubkey $active_pubkey
cleos set contract enu.token contracts/enu.token -p enu.token@active
cleos push action enu.token create\
  '{"issuer":"enu.token", "maximum_supply": "1000000000.0000 SYS"}' -p enu.token@active
cleos push action enu.token issue\
  '{"to":"enu.token", "quantity": "1000000000.0000 SYS", "memo": "issue"}' -p enu.token@active

# Deprecated: `currency` will be replaced by `currency3.14` below
cleos create account eosio currency $owner_pubkey $active_pubkey
cleos set contract currency contracts/enu.token -p currency@active
cleos push action currency create\
  '{"issuer":"currency", "maximum_supply": "1000000000.0000 CUR"}' -p currency@active
cleos push action currency issue\
  '{"to":"currency", "quantity": "1000000000.0000 CUR", "memo": "issue"}' -p currency@active

# eosio.* accounts  allowed only before lockdown

# Lockdown (deploy eosio.system or eosio.bios to the eosio account)
cleos set contract eosio contracts/eosio.system -p eosio@active

# Non-privileged operations (after lockdown)

# SYS (main token)
cleos transfer enu.token eosio '1000 SYS'
cleos transfer enu.token inita '1000 SYS'
cleos transfer enu.token initb '1000 SYS'
cleos transfer enu.token initc '1000 SYS'

# User-issued asset(s)..

# PHI (user-issued main token)
cleos push action enu.token create\
  '{"issuer":"enu.token", "maximum_supply": "1000000000.000 PHI"}' -p enu.token@active
cleos push action enu.token issue\
  '{"to":"enu.token", "quantity": "1000000000.000 PHI", "memo": "issue"}' -p enu.token@active
cleos transfer enu.token inita '100000 PHI'
cleos transfer enu.token initb '100000 PHI'

# CUR (user issued own contract)
# newaccount eosio currency3.14 $owner_pubkey $active_pubkey
# cleos set contract currency3.14 contracts/enu.token -p currency3.14@active
# cleos push action currency3.14 create\
#   '{"issuer":"currency3.14", "maximum_supply": "1000000000.0000 CUR"}' -p currency3.14@active
# cleos push action currency3.14 issue\
#   '{"to":"currency3.14", "quantity": "1000000000.0000 CUR", "memo": "issue"}' -p currency3.14@active
#
# # Nodeosd error: "Symbol CUR is not supported by token contract enu.token"
# cleos transfer currency3.14 inita '100000 CUR'
# cleos transfer currency3.14 initb '100000 CUR'
