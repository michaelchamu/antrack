'use strict'

# loading internal libraries
TopicModel = require('../models/topic').TopicModel

exports.TopicsController = class TopicsController

    _insertTopic = (topicData, callback) ->
        @tModel.create topicData, (creationError, creationResult) =>
            callback creationError, creationResult

    _getAllTopics = (callback) ->
        @tModel.findAll (findAllError, allTopics) =>
            callback findAllError, allTopics

    constructor: ->
        @tModel = new TopicModel

    insertTopic: (topicData, callback) =>
        _insertTopic.call @, topicData, (insertTopicError, insertTopicResult) =>
            callback insertTopicError, insertTopicResult

    getAllTopics: (callback) =>
        _getAllTopics.call @, (getAllError, allTopics) =>
            callback getAllError, allTopics
