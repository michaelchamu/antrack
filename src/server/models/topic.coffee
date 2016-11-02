'use strict'

DBManager = require('../util/db-manager').DBManager

exports.TopicModel = class TopicModel

    _create = (topicData, callback) ->
        DBManager.getInstance().getModel 'topic', (modelError, Topic) =>
            if modelError?
                callback modelError, null
            else
                newTopic = new Topic topicData
                newTopic.save (err) =>
                    if err?
                        callback err, null
                    else
                        callback null, "ok"

    _findAll = (callback) ->
        DBManager.getInstance().getModel 'topic', (modelError, Sighting) =>
            if modelError?
                callback modelError, null
            else
                Sighting.find {}, (findError, allTopics) =>
                    if findError?
                        callback findError, null
                    else
                        allEnglishNames = (topic.name_english for topic in allTopics)
                        allGermanNames = (topic.name_german for topic in allTopics)
                        topics =
                            english: allEnglishNames
                            german: allGermanNames
                        callback null, topics

    constructor: ->

    create: (topicData, callback) =>
        _create.call @, topicData, (createError, createResult) =>
            callback createError, createResult

    findAll: (callback) =>
        _findAll.call @, (findAllError, allTopics) =>
            callback findAllError, allTopics
