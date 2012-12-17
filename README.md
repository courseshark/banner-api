banner-api
==========

Interface between CourseShark server and Banner API given to us by Georgia Tech

The API to the Banner endpoints provided by Georgia Tech's OIT department for [courseshark](https://github.com/courseshark/courseshark).

## Example

    var user = {
        name: 'tj'
      , pets: ['tobi', 'loki', 'jane', 'bandit']
    };

    user.should.have.property('name', 'tj');
    user.should.have.property('pets').with.lengthOf(4);

    someAsyncTask(foo, function(err, result){
      should.not.exist(err);
      should.exist(result);
      result.bar.should.equal(foo);
    });

# Usage

## Authentication

Call `.authenticate` with a string then an object of settings

    var bannerAPI = require('banner-api')
    banner = bannerAPI('https://api.gatech.edu/apiv3/central.academics.course_catalog.{resource}/search');
    banner.authenticate('password', {
        app_id: process.env.NODE_GTAPI_ID
      , app_password: process.env.NODE_GTAPI_PASSWORD
    })

## Terms

Used to get a list of terms with optional parameters

