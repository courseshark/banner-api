https = require('https')
http = require('http')
urlUtil = require('url')
querystring = require('querystring')

userAgentString = 'CourseShark API-Crawler/nodejs 0.0.0'

exports = module.exports = (url) ->

  _rawUrl: url

  url: (resource) ->
    throw new Error('No url set') if !@_rawUrl
    return @_rawUrl if not resource
    @_rawUrl.replace(/\{resource\}/, resource)


  setUrl: (newUrl) ->
    throw new Error('Invalid url -- no {resource} parameter') if not newUrl.match(/\{resource\}/)
    @_rawUrl = newUrl

  authenticate: (method, credentials={}) ->
    @.credentials = credentials
    @.authType = method
    true

  apiCall: (resource, data={}, callback) ->
    if typeof data is 'function' and not callback
      [callback, data] = [data, callback]
      data = {}

    try
      url = @url(resource)
      throw new Error 'Missing authType, cannot make API call' if not @.authType
      # callback passed in with no data
    catch err
      callback err, null
      return

    #Append the authentication info to the data
    for key, value of @.credentials
      data['auth.'+key] = value

    @download(url, data, callback)


  download: (url, data, callback) ->
    urlParsed = urlUtil.parse url
    dlOptions =
      hostname: urlParsed.hostname
      host: urlParsed.host
      path: [urlParsed.path, querystring.stringify data].join('?')
      method: 'GET'
      port: if urlParsed.protocol is 'https:' then 443 else 80
      data: querystring.stringify data
      headers:
        'User-Agent':  userAgentString
      'user-agent': userAgentString

    if urlParsed.protocol is 'https:'
      httpOrHttps = https
      dlOptions.agent = new https.Agent(
          secureProtocol: 'SSLv3_method'
        , secureOptions: require('constants').SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS)
    else
      httpOrHttps = http

    req = httpOrHttps.request dlOptions, (res)->
      buffer = ''
      res.setEncoding 'utf-8'
      res.on 'data', (d)->
        buffer += d
      res.on 'end', ()->
        try
          bufferJson = JSON.parse(buffer)
          callback(null, bufferJson)
        catch err
          callback(null, buffer)

    req.on 'error', (e) ->
      callback(e)

    #Make the request
    req.end()

  getTerms: (options, callback) ->
    @apiCall('terms', options, callback)