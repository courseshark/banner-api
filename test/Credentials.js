var bannerAPI = require('../')
  , should = require('should');

describe('Credentials', function(){

  var banner;
  beforeEach(function(){
    banner = bannerAPI();
  })

  describe('.autenticate(method, credentials)', function(){
    it('should support "password"', function(){
      banner.authenticate("password").should.equal(true)
    })

    it('should set .credentials', function(){
      var creds = {app_id: 'foo', app_password: 'bar-secret'}
      banner.authenticate("password", creds)
      banner.credentials.should.equal(creds)
    })

    it('should set .authType', function(){
      var creds = {app_id: 'foo', app_password: 'bar-secret'}
      banner.authenticate("password", creds)
      banner.authType.should.equal("password")
    })
  })


})