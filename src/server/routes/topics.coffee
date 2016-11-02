'use strict'

TopicRequestHandler = require('../route-handlers/topic').TopicRequestHandler

module.exports = (app) ->

    # posting a new topic
    app.route('/api/topics').post (request, response) ->
        console.log "new POST request to /api/topics..."
        TopicRequestHandler.getInstance().insertTopic request, response

    # fetching all topics
    app.route('/api/topics').get (request, response) ->
        console.log "new GET request to /api/topics..."
        TopicRequestHandler.getInstance().getAllTopics request, response
