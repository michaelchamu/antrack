'use strict'

SightingRequestHandler = require('../route-handlers/sighting').SightingRequestHandler

module.exports = (app) ->
    # posting a new sighting
    app.route('/api/sightings').post (request, response) ->
        console.log "new POST request to /api/sightings..."
        SightingRequestHandler.getInstance().submitSighting request, response

    # getting all sightings
    app.route('/api/sightings').get (request, response) ->
        console.log "new GET request to /api/sightings..."
        SightingRequestHandler.getInstance().getSightings request, response

    # getting a specific sighting
    app.route('/api/sightings/:id').get (request, response) ->
        console.log "new GET request to /api/sightings/:id..."
        SightingRequestHandler.getInstance().getSighting request, response
