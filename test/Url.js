var bannerAPI = require('../')
  , should = require('should');

describe('Url', function(){

  describe('.setUrl(url)', function(){
    it('should inialize url on build', function(){
      var url = 'http://courseshark.com/apiv3/{resource}/search'
        , banner = bannerAPI(url);
      banner.url().should.equal(url)
    })

    it('should thow error if invalid url', function(){
      var url = 'http://courseshark.com/apiv3/search'
        , banner = bannerAPI();
      (function(){banner.setUrl(url)}).should.throwError()
    })

    it('should set the url when called', function(){
      var url = 'http://courseshark.com/apiv3/{resource}/search'
        , banner = bannerAPI();
      // Sets
      banner.setUrl(url)
      banner.url().should.equal(url)
    })

    it('should update the url when called', function(){
      var url = 'http://courseshark.com/apiv3/{resource}/search'
        , url2 = 'http://courseshark.com/api/{resource}'
        , banner = bannerAPI();
      // Sets
      banner.setUrl(url)
      banner.url().should.equal(url)

      // Change
      banner.setUrl(url2)
      banner.url().should.equal(url2)
    })
  })

  describe('.url(resource)', function(){

    it('should thow error when url not set', function(){
      var banner = bannerAPI();
      (function(){banner.url()}).should.throwError('No url set')
    })

    it('should return raw url when no resource set', function(){
      var url = 'http://courseshark.com/rawurl/{resource}'
        , banner = bannerAPI(url);
      banner.url().should.equal(url);
    })

    it('should replace resource in url', function(){
      var url = 'http://courseshark.com/apiv3/{resource}/search'
        , banner = bannerAPI(url);
      banner.url('foo').should.equal('http://courseshark.com/apiv3/foo/search')
      banner.url('bar').should.equal('http://courseshark.com/apiv3/bar/search')
      banner.url('crazy_thing').should.equal('http://courseshark.com/apiv3/crazy_thing/search')
    })
  })


})