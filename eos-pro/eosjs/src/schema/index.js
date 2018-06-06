const schema = Object.assign(
  {},
  require('./chain_types.json'),
  require('./enumivo_system.json'),
  require('./enumivo_token.json')
)

module.exports = schema
