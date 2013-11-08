class AbstractHttp extends XMLHttpRequest
  constructor: (@params = {type: null, url: null, async: true, dataType: 'json', data: null ,user: null, password: null}) ->
    @open(@params.type, @params.url, @params.async, @params.user, @params.password)
    @processRequest()

  processRequest:  ->
    @.onreadystatechange= ->
      if @.readyState is 4
        if @.status is 200
          console.log(@.response)




