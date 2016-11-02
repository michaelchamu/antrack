'use strict'

DescriptionRequestHandler = require('../route-handlers/description').DescriptionRequestHandler

module.exports = (app) ->
    # fetching all descriptions
    app.route('/api/descriptions').get (request, response) ->
        console.log "new GET request to /api/descriptions..."
        DescriptionRequestHandler.getInstance().getAllDescriptions request, response

    # posting a new description
    app.route('/api/descriptions').post (request, response) ->
        console.log "new POST request to /api/descriptions..."
        DescriptionRequestHandler.getInstance().insertDescription request, response
