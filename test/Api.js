var bannerAPI = require('../')
  , should = require('should');

describe('API', function(){

  var banner;
  beforeEach(function(){
    banner = bannerAPI('http://scooterlabs.com/{resource}.json')
    banner.authenticate('password', {app_id: 'mocha', app_password: 'foo'})
  })

  describe('.apiCall(resource, data, callback)', function(){
    it('should throw error if no url', function(done){
      var banner = bannerAPI();
      banner.apiCall('test', {}, function(err, res){
        err.should.be.an.instanceOf(Error)
        err.message.should.match(/No\surl\sset/)
        done();
      })
    })

    it('should throw error if no authType', function(done){
      var banner = bannerAPI('http://foo.com/api/{resource}');
      banner.apiCall('echo', {}, function(err, res){
        err.should.be.an.instanceOf(Error)
        err.message.should.match(/authType/)
        done();
      })
    })

    it('should treat data as optional parameter', function(done){
      banner.apiCall('echo', function(){
        done();
      })
    })

    it('should return something if no error', function(done){
      banner.apiCall('echo', {}, function(err, res){
        should.not.exist(err)
        should.exist(res)
        done();
      })
    })

    it('should return the request\'s JSON', function(done){
      banner.apiCall('echo', {test_request: '1002'}, function(err, res){
        should.exist(res)
        should.exist(res.request)
        should.exist(res.request.test_request)
        res.request.test_request.should.equal('1002')
        done();
      })
    })
  })

})