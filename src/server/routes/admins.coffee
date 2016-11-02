'use strict'

AdminRequestHandler = require('../route-handlers/admin').AdminRequestHandler

module.exports = (app) ->
    # loading all topics
    app.route('/api/load/topics').post (request, response) ->
        console.log "new POST request to /api/load/topics..."
        AdminRequestHandler.getInstance().loadTopics request, response

    # loading all initial sightings
    app.route('/api/load/sightings').post (request, response) ->
        console.log "new POST request to /api/load/sightings..."
        AdminRequestHandler.getInstance().loadSightings request, response

    # loading descriptions
    app.route('/api/load/descriptions').post (request, response) ->
        console.log "new POST request to /api/load/descriptions"
        AdminRequestHandler.getInstance().loadDescriptions request, response
