var bannerAPI = require('../')
  , should = require('should');

describe('API.Terms', function(){

  var banner;
  beforeEach(function(){
    banner = bannerAPI('http://foo.com/api/{resource}');
  })

  describe('.getTerms(options, callback)', function(){
    it('should treat data as optional parameter', function(done){
      banner.authenticate('password', {app_id: 'mocha', app_password: 'foo'})
      banner.getTerms('test', function(err, terms){
        done();
      })
    })
  })

})