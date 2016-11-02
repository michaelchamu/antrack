'use strict'

# loading internal libraries
SchemaValidator = require('./schema').SchemaValidator

exports.DescriptionValidator = class DescriptionValidator extends SchemaValidator

    _checkAndSanitizeDescriptionForInsertion = (descriptionData, callback) ->
        descriptionOptions =
            desc_english: (engDescPartialCallback) =>
                @sanitizationHelper.checkAndSanitizeWords descriptionData.desc_english, "English Description", @validator, (engWordError, validEnglishDescription) =>
                    engDescPartialCallback engWordError, validEnglishDescription
            desc_german: (gerDescPartialCallback) =>
                @sanitizationHelper.checkAndSanitizeWords descriptionData.desc_german, "German Description", @validator, (engWordError, validGermanDescription) =>
                    gerDescPartialCallback engWordError, validGermanDescription
        @flowController.parallel descriptionOptions, (descriptionDataError, validDescription) =>
            callback descriptionDataError, validDescription

    constructor: ->
        super()

    checkAndSanitizeDescriptionForInsertion: (descriptionData, callback) =>
        _checkAndSanitizeDescriptionForInsertion.call @, descriptionData, (descriptionDataError, validDescription) =>
            callback descriptionDataError, validDescription
