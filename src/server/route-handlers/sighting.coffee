'use strict'

# loading internal libraries
SightingsController = require('../controllers/sightings').SightingsController
SightingValidator   = require('../validators/sighting').SightingValidator

exports.SightingRequestHandler = class SightingRequestHandler
    _srhInstance = undefined

    # Get an instance of the handler
    @getInstance: ->
        _srhInstance ?= new _LocalSightingRequestHandler

    class _LocalSightingRequestHandler

        _submitSighting = (request, response) ->
            @sightingValidator.checkAndSanitizeSightingForInsertion request.body, (sightingDataError, validatedSightingData) =>
                if sightingDataError?
                    response.status(400).json({error: "Bad Request! #{sightingDataError.message}"})
                else
                    @sightingsController.submitSighting validatedSightingData, (submitSightingError, submitSightingResult) =>
                        if submitSightingError?
                            response.status(500).json({error: "Internal Server Error! #{submitSightingError.message}"})
                        else
                            response.status(201).json(submitSightingResult)

        _getAllSightings = (request, response) ->
            @sightingsController.getAllSightings (allSightingsError, allSightings) =>
                if allSightingsError?
                    response.status(500).json({error: "Internal Error! #{allSightingsError.message}"})
                else if allSightings.length isnt 0
                    response.status(200).json(allSightings)
                else
                    response.status(404).json({error: "Sighting Not Found"})

        _getRecentSightings = (request, response) ->
            @sightingValidator.checkAndSanitizeAge request.query.days, (sightingAgeError, validSightingAge) =>
                if sightingAgeError?
                    response.status(400).json({error: sightingAgeError.message})
                else
                    @sightingsController.getRecentSightings validSightingAge, (sightingsError, sightings) =>
                        if sightingsError?
                            response.status(500).json({error: sightingsError.message})
                        else
                            if sightings.length > 0
                                response.status(200).json(sightings)
                            else
                                response.status(404).json({error: "All sightings older than #{validSightingAge} days"})

        _getSighting = (request, response) ->
            @sightingValidator.checkAndSanitizeID request.params.id, (sightingIDError, validSightingID) =>
                if sightingIDError?
                    response.status(400).json({error: "Bad Request! #{sightingIDError.message}"})
                else
                    @sightingsController.getSighting validSightingID, (sightingError, sighting) =>
                        if sightingError?
                            response.status(500).json({error: "Internal Error! #{sightingError.message}"})
                        else if sighting?
                            response.status(200).json(sighting)
                        else
                            response.status(401).json({error: "Sighting Not Found"})

        _getSightingWithCriteria = (request, response) ->
            if request.query.days?
                _getRecentSightings.call @, request, response
            else
                queryOptions =
                    keyword: request.query.keyword
                    location: request.query.location
                    timestamp: request.query.timestamp
                @sightingValidator.checkAndSanitizeSearchCriteria queryOptions, (criteriaError, validCriteria) =>
                    if criteriaError?
                        response.status(400).json({error: "Bad Request! #{criteriaError.message}"})
                    else
                        @sightingsController.getSightingsWithCriteria validCriteria, (sightingsError, sightings) =>
                            if sightingsError?
                                response.status(500).json({error: "Internal Error! #{sightingError.message}"})
                            else
                                if sightings.length > 0
                                    response.status(200).json(sightings)
                                else
                                    response.status(404).json({error: "Sighting Not Found"})

        _getSightings = (request, response) ->
            if not (request.query.keyword? or request.query.location? or request.query.timestamp? or request.query.days)
                _getAllSightings.call @, request, response
            else
                _getSightingWithCriteria.call @, request, response

        constructor: ->
            @sightingsController = new SightingsController
            @sightingValidator = new SightingValidator

        submitSighting: (request, response) =>
            _submitSighting.call @, request, response

        getAllSightings: (request, response) =>
            _getAllSightings.call @, request, response

        getSighting: (request, response) =>
            _getSighting.call @, request, response

        getSightingsWithCriteria: (request, response) =>
            _getSightingWithCriteria.call @, request, response

        getSightings: (request, response) =>
            _getSightings.call @, request, response
