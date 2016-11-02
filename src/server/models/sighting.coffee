'use strict'

# load internal libraries
DBManager = require('../util/db-manager').DBManager

# load external libraries
moment = require 'moment'

exports.SightingModel = class SightingModel
    _create = (sightingData, callback) ->
        DBManager.getInstance().getModel 'sighting', (modelError, Sighting) =>
            if modelError?
                callback modelError, null
            else
                newSighting = new Sighting sightingData
                newSighting.save (err) =>
                    if err?
                        callback err, null
                    else
                        callback null, "ok"

    _findAll = (callback) ->
        _findWithCriteria.call @, {}, (findError, allSightings) =>
            callback findError, allSightings

    _findByID = (sightingID, callback) ->
        DBManager.getInstance().getModel 'sighting', (modelError, Sighting) =>
            if modelError?
                callback modelError, null
            else
                Sighting.findById sightingID, (findError, sighting) =>
                    callback findError, sighting

    _findWithCriteria = (criteria, callback) ->
        DBManager.getInstance().getModel 'sighting', (modelError, Sighting) =>
            if modelError?
                callback modelError, null
            else
                Sighting.find criteria, (findError, allSightings) =>
                    callback findError, allSightings

    _findRecent = (age, callback) ->
        _findAll.call @, (findAllError, allSightings) =>
            if findAllError?
                callback findAllError, null
            else
                recentSightings =  []
                now = moment()
                olderLimitDate = moment().subtract age, 'days'
                for curSighting in allSightings
                    do (curSighting) =>
                        # recentSightings.push "#{curSighting.timestamp} and now is #{now}, olderlimit is #{olderLimitDate} and comparison #{moment(curSighting.timestamp).isBetween(olderLimitDate, now)}"
                        recentSightings.push curSighting if moment(curSighting.timestamp).isBetween(olderLimitDate, now)
                callback null, recentSightings

    constructor: ->

    create: (sightingData, callback) =>
        _create.call @, sightingData, (createError, createResult) =>
            callback createError, createResult

    findAll: (callback) =>
        _findAll.call @, (findAllError, allSightings) =>
            callback findAllError, allSightings

    findByID: (sightingID, callback) =>
        _findByID.call @, sightingID, (sightingError, sighting) =>
            callback sightingError, sighting

    findWithCriteria: (criteria, callback) =>
        _findWithCriteria.call @, criteria, (findError, sightings) =>
            callback findError, sightings

    findRecent: (age, callback) =>
        _findRecent.call @, age, (findError, sightings) =>
            callback findError, sightings
