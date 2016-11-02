'use strict'

csv = require 'fast-csv'
fs  = require 'fs'

exports.Extractor = class Extractor

    _csvExtractorInstance = undefined

    @getInstance: ->
        _csvExtractorInstance ?= new _LocalExtractor

    class _LocalExtractor

        _extractSingleSighting = (csvSightingData) ->
            transformedSighting =
                location:
                    latitude: csvSightingData.Latitude
                    longitude: csvSightingData.Longitude
                keyword: csvSightingData.Animal
                description: csvSightingData.Description
                timestamp: csvSightingData.Timestamp
            return transformedSighting

        _extractSingleTopic = (csvTopicData) ->
            transformedTopic =
                name_english: csvTopicData.Animal_en
                name_german: csvTopicData.Animal_de
            return transformedTopic

        _extractSingleDescription = (csvDescriptionData) ->
            transformedDescription =
                desc_english: csvDescriptionData.Description_en
                desc_german: csvDescriptionData.Description_de
            return transformedDescription

        _genericExtractData = (csvFileName, csvExtractorFunc, callback) ->
            convertedArray = []
            parseOptions =
                objectMode: true
                delimiter: ','
                headers: true
            genericStream = fs.createReadStream csvFileName
            extractSingleData = (genericData) ->
                convertedArray.push(csvExtractorFunc.call @, genericData)
            completeExtraction = ->
                callback null, convertedArray
            genericCSVStream = csv
                .parse(parseOptions)
                .on('data', extractSingleData)
                .on('end', completeExtraction)
            genericStream.pipe  genericCSVStream

        _extractSightings = (callback) ->
            _genericExtractData.call @, "#{__dirname}/../../../design/database/table_sightings.csv", _extractSingleSighting, callback

        _extractTopics = (callback) ->
            _genericExtractData.call @, "#{__dirname}/../../../design/database/table_animals.csv", _extractSingleTopic, callback

        _extractDescriptions = (callback) ->
            _genericExtractData.call @, "#{__dirname}/../../../design/database/table_descriptions.csv", _extractSingleDescription, callback

        constructor: ->

        extractSightings: (callback) =>
            _extractSightings.call @, (loadSightingsError, loadSightingsResult) =>
                callback loadSightingsError, loadSightingsResult

        extractTopics: (callback) =>
            _extractTopics.call @, (loadTopicsError, loadTopicsResult) =>
                callback loadTopicsError, loadTopicsResult

        extractDescriptions: (callback) =>
            _extractDescriptions.call @, (loadDescriptionsError, loadDescriptionsResult) =>
                callback loadDescriptionsError, loadDescriptionsResult
