'use strict'

# loading internal libraries
SchemaValidator = require('./schema').SchemaValidator

exports.TopicValidator = class TopicValidator extends SchemaValidator

    _checkAndSanitizeTopicForInsertion = (topicData, callback) ->
        topicOptions =
            name_english: (engNamePartialCallback) =>
                @sanitizationHelper.checkAndSanitizeWord topicData.name_english, "English Topic Name", @validator, (wordError, validEnglishName) =>
                    engNamePartialCallback wordError, validEnglishName
            name_german: (gerNamePartialCallback) =>
                @sanitizationHelper.checkAndSanitizeWord topicData.name_english, "German Topic Name", @validator, (wordError, validGermanName) =>
                    gerNamePartialCallback wordError, validGermanName
        @flowController.parallel topicOptions, (topicDataError, validTopicData) =>
            callback topicDataError, validTopicData

    constructor: ->
        super()

    checkAndSanitizeTopicForInsertion: (topicData, callback) =>
        _checkAndSanitizeTopicForInsertion.call @, topicData, (topicDataError, validTopic) =>
            callback topicDataError, validTopic
