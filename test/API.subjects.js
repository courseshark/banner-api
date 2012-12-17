var bannerAPI = require('../')
  , should = require('should');

describe('API.Subjects', function(){

  var banner;
  beforeEach(function(){
    banner = bannerAPI('https://api.gatech.edu/apiv3/central.academics.course_catalog.{resource}/search');
    banner.authenticate('password', {
        app_id: process.env.NODE_GTAPI_ID
      , app_password: process.env.NODE_GTAPI_PASSWORD
    })
  })

  describe('.getSubjects(term, callback)', function(){
    it('should throw error if no term specified', function(done){
      banner.getSubjects(false, function(err, terms){
        err.should.be.an.instanceOf(Error)
        err.message.should.match(/term/)
        done()
      })
    })

    it('should return the subjects for a term specified', function(done){
      banner.getSubjects(201208, function(err, subjects){
        subjects.should.be.an.instanceOf(Array)
        subjects.length.should.be.above(1)
        done()
      })
    })
  })

  describe('.getDepartments(term, callback', function(){
    it('should just be an alias for .getSubjects', function(done){
      banner.getDepartments(201208, function(err, departments){
        departments.should.be.an.instanceOf(Array)
        departments.length.should.be.above(1)
        done()
      })
    })
  })

})