'use strict'

# loading internal libraries
TopicsController = require('../controllers/topics').TopicsController
TopicValidator   = require('../validators/topic').TopicValidator

exports.TopicRequestHandler = class TopicRequestHandler
    _trhInstance = undefined

    # Get an instance of the handler
    @getInstance: ->
        _trhInstance ?= new _LocalTopicRequestHandler

    class _LocalTopicRequestHandler

        _insertTopic = (request, response) ->
            # do the validation first
            @topicValidator.checkAndSanitizeTopicForInsertion request.body, (topicDataError, validatedTopicData) =>
                if topicDataError?
                    response.status(400).json({error: 'Bad Request'})
                else
                    @topicsController.insertTopic validatedTopicData, (insertTopicError, insertTopicResult) =>
                        if insertTopicError?
                            response.status(500).json({error: insertTopicError.message})
                        else
                            response.status(201).json(insertTopicResult)

        _getAllTopics = (request, response) ->
            @topicsController.getAllTopics (getAllError, allTopics) =>
                if getAllError?
                    response.status(500).json({error: "Internal Error! #{getAllError.message}"})
                else if allTopics.length isnt 0
                    response.status(200).json(allTopics)
                else
                    response.status(404).json({error: "Topic Not Found!"})

        constructor: ->
            @topicValidator   = new TopicValidator
            @topicsController = new TopicsController

        insertTopic: (request, response) =>
            _insertTopic.call @, request, response

        getAllTopics: (request, response) =>
            _getAllTopics.call @, request, response
