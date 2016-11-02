'use strict'

DBManager = require('../util/db-manager').DBManager

exports.DescriptionModel = class DescriptionModel

    _create = (descriptionData, callback) ->
        DBManager.getInstance().getModel 'description', (modelError, Description) =>
            if modelError?
                callback modelError, null
            else
                newDescription = new Description descriptionData
                newDescription.save (err) =>
                    if err?
                        callback err, null
                    else
                        callback null, "ok"

    _findAll = (callback) ->
        DBManager.getInstance().getModel 'description', (modelError, Description) =>
            if modelError?
                callback modelError, null
            else
                Description.find {}, (findError, allDescriptions) =>
                    if findError?
                        callback findError, null
                    else
                        allEnglishNames = (desc.desc_english for desc in allDescriptions)
                        allGermanNames = (desc.desc_german for desc in allDescriptions)
                        descriptions =
                            english: allEnglishNames
                            german: allGermanNames
                        callback null, descriptions

    constructor: ->

    create: (descriptionData, callback) =>
        _create.call @, descriptionData, (createError, createResult) =>
            callback createError, createResult

    findAll: (callback) =>
        _findAll.call @, (findAllError, allDescriptions) =>
            callback findAllError, allDescriptions
