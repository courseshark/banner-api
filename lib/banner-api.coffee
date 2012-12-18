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
      data['api.'+key] = value

    @download(url, data, callback)


  # Internal Downloader method
  download: (url, data, callback) ->
    # Options:
    #   url: String url to hit
    #   data: GET parameters
    #   callback: function accepts err and result
    urlParsed = urlUtil.parse url
    data.api_request_mode = data.api_request_mode or 'sync'
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

    # Setup http or https depending on URL
    if urlParsed.protocol is 'https:'
      httpOrHttps = https
      # Tell the agent to accept old SSL
      dlOptions.agent = new https.Agent(
          secureProtocol: 'SSLv3_method'
        , secureOptions: require('constants').SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS)
    else
      httpOrHttps = http
    #Setup request
    req = httpOrHttps.request dlOptions, (res)->
      buffer = ''
      res.setEncoding 'utf-8'
      res.on 'data', (d)->
        buffer += d
      res.on 'end', ()->
        try
          bufferJson = JSON.parse(buffer)
          if bufferJson.api_result_data
            resultData = JSON.parse bufferJson.api_result_data
            callback null, resultData
          else if bufferJson.api_error_info
            # The API returned an error, so turn it into an error object and forward it back (with the response object)
            err = new Error(bufferJson.api_error_info.message)
            err.result_code = bufferJson.api_error_info.result_code
            err.type = bufferJson.api_error_info.type
            err.log = bufferJson.api_provider_logs
            callback err, bufferJson
        catch err
          # Returned result was not JSON formot
          callback new Error 'Invalid JSON response', buffer
    #Request eror handler
    req.on 'error', (e) ->
      callback(e)
    #Make the request
    req.end()

  cleanJSONResponse: (dirtyJson) ->
    cleanString = resultString.replace /[\\n\n]/gi, ''

  getTerms: (options, callback) ->
    # Options:
    #   start_date_from: YYYY-MM-DD
    #   start_date_to: YYYY-MM-DD
    #   end_date_from YYYY-MM-DD
    #   end_date_from YYYY-MM-DD
    if typeof options is 'function' and not callback
      callback = options
      options = {}
    @apiCall 'terms', options, (err, res)->
      callback err, res?.api_result_data or res



  # An alias for getSubjects
  getDepartments: ->
    @.getSubjects.apply(@, arguments)

  # Get the subjects taught for a term
  getSubjects: (termCode, callback) ->
    # Options:
    # * term_code: xxxxxx
    return callback(new Error('Missing required term_code')) if not termCode
    @apiCall 'subjects', {term_code: termCode}, callback
