var bannerAPI = require('../')
  , should = require('should');

describe('API.Terms', function(){

  var banner;
  beforeEach(function(){
    banner = bannerAPI('https://api.gatech.edu/apiv3/central.academics.course_catalog.{resource}/search');
    banner.authenticate('password', {
        app_id: process.env.NODE_GTAPI_ID
      , app_password: process.env.NODE_GTAPI_PASSWORD
    })
  })

  describe('.getTerms(options, callback)', function(){
    it('should take options optionally', function(done){
      var banner = bannerAPI('http://scooterlabs.com/echo.json?{resource}')
      banner.authenticate('password', {app_id: 'mocha', app_password: 'foo'})
      banner.getTerms(function(err, terms){
        done();
      })
    })
    it('should return terms', function(done){
      banner.getTerms(function(err, terms){
        err.should.not.be.an.instanceOf(Error)
        terms.should.be.an.instanceOf(Array)
        terms.length.should.be.above(1)
        done();
      })
    })
  })
})