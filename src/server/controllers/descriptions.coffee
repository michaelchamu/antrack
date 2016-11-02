'use strict'

# loading internal libraries
DescriptionModel = require('../models/description').DescriptionModel

exports.DescriptionsController = class DescriptionsController

    _getAllDescriptions = (callback) ->
        @descModel.findAll (findAllError, allDescriptions) =>
            callback findAllError, allDescriptions

    _insertDescription = (descriptionData, callback) ->
        @descModel.create descriptionData, (creationError, creationResult) =>
            callback creationError, creationResult

    constructor: ->
        @descModel = new DescriptionModel

    insertDescription: (descriptionData, callback) =>
        _insertDescription.call @, descriptionData, (insertDescriptionError, insertDescriptionResult) =>
            callback insertDescriptionError, insertDescriptionResult

    getAllDescriptions: (callback) =>
        _getAllDescriptions.call @, (getAllError, allDescriptions) =>
            callback getAllError, allDescriptions
