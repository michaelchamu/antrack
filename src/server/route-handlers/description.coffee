'use strict'

# loading internal libraries
DescriptionsController = require('../controllers/descriptions').DescriptionsController
DescriptionValidator   = require('../validators/description').DescriptionValidator

exports.DescriptionRequestHandler = class DescriptionRequestHandler
    _descInstance = undefined

    @getInstance: ->
        _descInstance ?= new _LocalDescriptionRequestHandler

    class _LocalDescriptionRequestHandler

        _getAllDescriptions = (request, response) ->
            @descriptionsController.getAllDescriptions (getAllError, allDescriptions) =>
                if getAllError?
                    response.status(500).json({error: "Internal Error! #{getAllError.message}"})
                else if allDescriptions.length isnt 0
                    response.status(200).json(allDescriptions)
                else
                    response.status(404).json({error: "Description Not Found!"})

        _insertDescription = (request, response) ->
            # do the validation first
            @descriptionValidator.checkAndSanitizeDescriptionForInsertion request.body, (descriptionDataError, validatedDescriptionData) =>
                if descriptionDataError?
                    response.status(400).json({error: 'Bad Request'})
                else
                    @descriptionsController.insertDescription validatedDescriptionData, (insertDescriptionError, insertDescriptionResult) =>
                        if insertDescriptionError?
                            response.status(500).json({error: insertDescriptionError.message})
                        else
                            response.status(201).json(insertDescriptionResult)

        constructor: ->
            @descriptionValidator = new DescriptionValidator
            @descriptionsController = new DescriptionsController

        insertDescription: (request, response) =>
            _insertDescription.call @, request, response

        getAllDescriptions: (request, response) =>
            _getAllDescriptions.call @, request, response
