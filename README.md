banner-api
==========

Interface between CourseShark server and Banner API given to us by Georgia Tech

The API to the Banner endpoints provided by Georgia Tech's OIT department for [courseshark](https://github.com/courseshark/courseshark).

# Testing

    make test

# Usage

## Authentication
__.authenticate(type, options)__

Call `.authenticate` with a string then an object of settings

    var bannerAPI = require('banner-api')
    banner = bannerAPI('https://api.gatech.edu/apiv3/central.academics.course_catalog.{resource}/search');
    banner.authenticate('password', {
        app_id: process.env.NODE_GTAPI_ID
      , app_password: process.env.NODE_GTAPI_PASSWORD
    })

## Terms
__.getTerms(options, callback)__

Used to get a list of terms with optional parameters

## Subjects
__.getSubjects(termCode, callback)__ _or_ __.getDepartments(termCode, callback)__


