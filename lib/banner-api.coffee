require('coffee-script')

exports = module.exports = () ->
  authenticate: (method, credentials={}) -> 
    @.credentials = credentials
    @.authType = method
    true