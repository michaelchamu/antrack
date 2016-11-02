'use strict'

# loading internal libraries
SchemaValidator = require('./schema').SchemaValidator

exports.SightingValidator = class SightingValidator extends SchemaValidator

    _checkAndSanitizeSightingForInsertion = (sightingData, callback) ->
        sightingOptions =
            keyword: (keywordPartialCallback) =>
                @sanitizationHelper.checkAndSanitizeWord sightingData.keyword, "keyword", @validator, (keywordError, validKeyword) =>
                    keywordPartialCallback keywordError, validKeyword
            location: (locationParitalCallback) =>
                _checkAndSanitizeLocation.call @, sightingData.location, (locationError, validLocation) =>
                    locationParitalCallback locationError, validLocation
            description: (descriptionPartialCallback) =>
                _checkAndSanitizeDescription.call @, sightingData.description, (descriptionError, validDescription) =>
                    descriptionPartialCallback descriptionError, validDescription
            timestamp: (timestampPartialCallback) =>
                _checkAndSanitizeTimestamp.call @, sightingData.timestamp, (timestampError, validTimestamp) =>
                    timestampPartialCallback timestampError, validTimestamp
        @flowController.parallel sightingOptions, (sightingDataError, validSightingData) =>
            callback sightingDataError, validSightingData

    _checkAndSanitizeLocationLatitude = (latitude, callback) ->
        @sanitizationHelper.checkAndSanitizeDecimal latitude, 'latitude', @validator, (latitudeError, validLatitude) =>
            callback latitudeError, validLatitude

    _checkAndSanitizeLocationLongitude = (longitude, callback) ->
        @sanitizationHelper.checkAndSanitizeDecimal longitude, 'longitude', @validator, (longitudeError, validLongitude) =>
            callback longitudeError, validLongitude

    _checkAndSanitizeLocationName = (name, callback) ->
        @sanitizationHelper.checkAndSanitizeWords name, 'Location Name', @validator, (nameError, validName) =>
            callback nameError, validName

    _checkAndSanitizeLocation = (locationData, callback) ->
        _checkAndSanitizeLocationLatitude.call @, locationData.latitude, (locationLatitudeError, validLocationLatitude) =>
            if locationLatitudeError?
                callback locationLatitudeError, null
            else
                _checkAndSanitizeLocationLongitude.call @, locationData.longitude, (locationLongitudeError, validLocationLongitude) =>
                    if locationLongitudeError?
                        callback locationLongitudeError, null
                    else
                        if not locationData.name?
                            validLocationWithoutName =
                                latitude: validLocationLatitude
                                longitude: validLocationLongitude
                            callback null, validLocationWithoutName
                        else
                            _checkAndSanitizeLocationName.call @, locationData.name, (locationNameError, validLocationName) =>
                                if locationNameError?
                                    callback locationNameError, null
                                else
                                    validLocation =
                                        name: validLocationName
                                        latitude: validLocationLatitude
                                        longitude: validLocationLongitude
                                    callback null, validLocation

    _checkAndSanitizeTimestamp = (timestamp, callback) ->
        @sanitizationHelper.checkAndSanitizeDate timestamp, @validator, (timestampError, validtimestamp) =>
            callback timestampError, validtimestamp

    _checkAndSanitizeRegistrationID = (registrationIdValue, callback) ->
        @sanitizationHelper.checkAndSanitizeID registrationIdValue, "registration ID", @validator, (registrationIDError, validRegistrationID) =>
            callback registrationIDError, validRegistrationID

    _checkAndSanitizeDescription = (descriptionData, callback) ->
        @sanitizationHelper.checkAndSanitizeWords descriptionData, 'description', @validator, (descriptionError, validDescription) =>
            callback descriptionError, validDescription

    _checkAndSanitizeTimestamp = (timestampData, callback) ->
        @sanitizationHelper.checkAndSanitizeDate timestampData, @validator, (timestampError, validTimestamp) =>
            callback timestampError, validTimestamp

    _checkAndSanitizeID = (sightingID, callback) ->
        @sanitizationHelper.checkAndSanitizeMongoID sightingID, @validator, (sightingIDError, validSightingID) =>
            callback sightingIDError, validSightingID

    _checkAndSanitizeSearchCriteria = (criteria, callback) ->
        criteriaOptions = {}
        # load each criterion only if it exits
        if criteria.keyword?
            keywordOption = (keywordPartialCallback) =>
                @sanitizationHelper.checkAndSanitizeWord criteria.keyword, "keyword", @validator, (keywordError, validKeyword) =>
                    keywordPartialCallback keywordError, validKeyword
            criteriaOptions["keyword"] = keywordOption
        if criteria.location?
            locationOption = (locationParitalCallback) =>
                _checkAndSanitizeLocation.call @, criteria.location, (locationError, validLocation) =>
                    locationParitalCallback locationError, validLocation
            criteriaOptions["location"] = locationOption
        if criteria.timestamp?
            timestampOption = (timestampPartialCallback) =>
                _checkAndSanitizeTimestamp.call @, criteria.timestamp, (timestampError, validTimestamp) =>
                    timestampPartialCallback timestampError, validTimestamp
            criteriaOptions["timestamp"] = timestampOption
        # run the validation in parallel for all entries
        @flowController.parallel criteriaOptions, (criteriaDataError, validatedCriteria) =>
            if criteriaDataError?
                callback criteriaDataError, null
            else
                callback null, validatedCriteria

    _checkAndSanitizeAge = (sightingAge, callback) ->
        @sanitizationHelper.checkAndSanitizeNumber sightingAge, 'Sighting Age', @validator, (ageError, validAge) =>
            callback ageError, validAge

    constructor: ->
        super()

    checkAndSanitizeSightingForInsertion: (sightingData, callback) =>
        _checkAndSanitizeSightingForInsertion.call @, sightingData, (sightingDataError, validSighting) =>
            callback sightingDataError, validSighting

    checkAndSanitizeID: (sightingID, callback) =>
        _checkAndSanitizeID.call @, sightingID, (sightingIDError, validSightingID) =>
            callback sightingIDError, validSightingID

    checkAndSanitizeSearchCriteria: (criteria, callback) =>
        _checkAndSanitizeSearchCriteria.call @, criteria, (criteriaError, validCriteria) =>
            callback criteriaError, validCriteria

    checkAndSanitizeAge: (sightingAge, callback) =>
        _checkAndSanitizeAge.call @, sightingAge, (sightingAgeError, validSightingAge) =>
            callback sightingAgeError, validSightingAge
