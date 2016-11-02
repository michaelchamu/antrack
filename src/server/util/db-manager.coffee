'use strict'

mongoose = require 'mongoose'

exports.DBManager = class DBManager
    _dbManagerInstance = undefined

    @getInstance: ->
        _dbManagerInstance ?= new _LocalDBManager

    class _LocalDBManager

        _connect = (dbName, connectionErrorCallback, disconnectedCallback, connectionCallback) ->
            # define database url
            dbURL = "mongodb://127.0.0.1:27017/#{dbName}"
            mongoose.connect dbURL

            mongoose.connection.on 'error',  connectionErrorCallback

            mongoose.connection.on 'disconnected', disconnectedCallback

            mongoose.connection.on 'connected', connectionCallback

        _createSightingSchema = ->
            sightingSchemaOptions =
                location:
                    name:
                        type: String
                        required: false
                    latitude:
                        type: Number
                        require: true
                    longitude:
                        type: Number
                        required: true
                keyword:
                    type: String
                    required: true
                description:
                    type: String
                    required: false
                registrationId:
                    type: String
                    required: false
                timestamp:
                    type: Date
                    default: Date.now
                    required: true
            sightingSchema = mongoose.Schema sightingSchemaOptions
            return sightingSchema

        _createTopicSchema = ->
            topicSchemaOptions =
                name_english:
                    type: String
                    required: true
                name_german:
                    type: String
                    required: true
            topicSchema = mongoose.Schema topicSchemaOptions
            return topicSchemaOptions

        _createDesriptionSchema = ->
            descriptionSchemaOptions =
                desc_english:
                    type: String
                    required: true
                desc_german:
                    type: String
                    required: true
            descriptionSchema = mongoose.Schema descriptionSchemaOptions
            return descriptionSchema

        _createSchemas = ->
            createdSchemas =
                sighting: _createSightingSchema.call @
                topic: _createTopicSchema.call @
                description: _createDesriptionSchema.call @
            return createdSchemas

        _getModel = (name, callback) ->
            currentModel = @allModels[name]
            if currentModel?
                callback null, currentModel
            else
                theSchema = @allSchemas[name]
                if not theSchema?
                    noSchemaError = new Error "Error! no schema for #{name}"
                else
                    newModel = mongoose.model name, theSchema
                    @allModels[name] = newModel
                    callback null, newModel

        constructor: ->
            @allSchemas = @createSchemas()
            @allModels = {}

        createSchemas: ->
            _createSchemas.call @

        connect: (dbName, connectionErrorCallback, disconnectedCallback, connectionCallback) =>
            _connect.call @, dbName, connectionErrorCallback, disconnectedCallback, connectionCallback

        getModel: (name, callback) =>
            _getModel.call @, name, (modelError, model) =>
                callback modelError, model
