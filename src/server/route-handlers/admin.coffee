'use strict'

async = require 'async'

 #loading internal libraries
DescriptionsController = require('../controllers/descriptions').DescriptionsController
DescriptionValidator   = require('../validators/description').DescriptionValidator
Extractor              = require('../util/csv-extractors').Extractor
SightingsController    = require('../controllers/sightings').SightingsController
SightingValidator      = require('../validators/sighting').SightingValidator
TopicsController       = require('../controllers/topics').TopicsController
TopicValidator         = require('../validators/topic').TopicValidator

exports.AdminRequestHandler = class AdminRequestHandler
    _admInstance = undefined

    @getInstance: ->
        _admInstance ?= new _LocalAdminRequestHandler

    class _LocalAdminRequestHandler
        _genericLoad = (request, response, extractionFunName, validatorObj, validationFun, controllerObj, loadFun) ->
            # first extract the right object
            Extractor.getInstance()[extractionFunName] (extractItemsError, extractedItems) =>
                if extractItemsError?
                    response.status(500).json({error: extractItemsError.message})
                else
                    # validate all the extracted ites
                    itemValidators = []
                    # Step 1: generate the validation functions on the fly
                    for curItem in extractedItems
                        do (curItem) =>
                            itemValidationFunc = (partialValidationCallback) =>
                                validatorObj[validationFun] curItem, (itemValidationError, validatedItemData) =>
                                    partialValidationCallback itemValidationError, validatedItemData
                            itemValidators.push itemValidationFunc
                    # Step 2: execute the validation
                    async.parallel itemValidators, (validationError, validatedItems) =>
                        if validationError?
                            response.status(400).json({error: "Bad Request!"})
                        else
                            # load the validated item
                            itemInserters = []
                            # Step 1: generate the load functions on the fly
                            for curItem2 in validatedItems
                                do (curItem2) =>
                                    itemInsertionFunc = (partialInsertionCallback) =>
                                        controllerObj[loadFun] curItem2, (insertItemError, insertItemResult) =>
                                            partialInsertionCallback insertItemError, insertItemResult
                                    itemInserters.push itemInsertionFunc
                            # Step2: execute the load
                            async.series itemInserters, (insertionError, insertionResult) =>
                                if insertionError?
                                    response.status(500).json({error: insertionError.message})
                                else
                                    response.status(201).json(insertionResult)

        _loadDescriptions = (request, response) ->
            _genericLoad.call @, request, response, "extractDescriptions", @descriptionValidator, "checkAndSanitizeDescriptionForInsertion", @descriptionsController, "insertDescription"

        _loadSightings = (request, response) ->
            _genericLoad.call @, request, response, "extractSightings", @sightingValidator, "checkAndSanitizeSightingForInsertion", @sightingsController, "submitSighting"

        _loadTopics = (request, response) ->
            _genericLoad.call @, request, response, "extractTopics", @topicValidator, "checkAndSanitizeTopicForInsertion", @topicsController, "insertTopic"

        constructor: ->
            @descriptionValidator = new DescriptionValidator
            @descriptionsController = new DescriptionsController
            @sightingsController = new SightingsController
            @sightingValidator = new SightingValidator
            @topicValidator   = new TopicValidator
            @topicsController = new TopicsController

        loadTopics: (request, response) =>
            _loadTopics.call @, request, response

        loadDescriptions: (request, response) =>
            _loadDescriptions.call @, request, response

        loadSightings: (request, response) =>
            _loadSightings.call @, request, response
