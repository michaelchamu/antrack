'use strict'

# load external libraries
gcm = require 'node-gcm'

# load internal libraries
SightingModel = require('../models/sighting').SightingModel

exports.SightingsController = class SightingsController

    _submitSighting = (sightingData, callback) ->
        @stModel.create sightingData, (creationError, creationResult) =>
            if createError?
                console.log "error storing in the data store..."
                callback createError, null
            else
                # check whether the topic belongs to a list of  protected
                # topic names
                priority: 'high'
                data:
                    location =
                        name: sightingData.location.name
                        latitude: sightingData.location.latitude
                        longitude: sightingData.location.longitude
                notificationOptions =
                    title: 'New Sighting'
                    body: 'A '+sightingData.keyword+' was spotted.';
                    sound: 'default'
                    badge: '1'
                message = new gcm.Message()
                message.addNotification notificationOptions
                sender = new gcm.Sender("AIzaSyCXDeAYpSoJQOg_YhPhSdcbcnmRoR4j1go")
                sender.sendNoRetry message, {topic: "/topics/"+sightingData.keyword}, (notificationError, notificationResponse) =>
                    if notificationError?
                        console.log notificationError
                        callback notificationError, null
                    else
                        console.log notificationResponse
                        callback null, "ok"

    _getAllSightings = (callback) ->
        @stModel.findAll (findAllError, allSightings) =>
            callback findAllError, allSightings

    _getSighting = (sightingID, callback) ->
        @stModel.findByID sightingID, (findError, sighting) =>
            callback findError, sighting

    _getSightingWithCriteria = (searchCriteria, callback) ->
        @stModel.findWithCriteria searchCriteria, (findError, sightings) =>
            callback findError, sightings

    _getRecentSightings = (sightingAge, callback) ->
        @stModel.findRecent sightingAge, (findError, sightings) =>
            callback findError, sightings

    constructor: ->
        @stModel = new SightingModel

    submitSighting: (sightingData, callback) =>
        _submitSighting.call @, sightingData, (submitError, submitResult) =>
            callback submitError, submitResult

    getAllSightings: (callback) =>
        _getAllSightings.call @, (allSightingsError, allSightings) =>
            callback allSightingsError, allSightings

    getSighting: (sightingID, callback) =>
        _getSighting.call @, sightingID, (sightingError, sighting) =>
            callback sightingError, sighting

    getSightingsWithCriteria: (searchCriteria, callback) =>
        _getSightingWithCriteria.call @, searchCriteria, (sightingsError, sightings) =>
            callback sightingsError, sightings

    getRecentSightings: (sightingAge, callback) =>
        _getRecentSightings.call @,  sightingAge, (sightingsError, sightings) =>
            callback sightingsError, sightings
