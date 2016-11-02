'use strict'

exports.SanitizationHelper = class SanitizationHelper

    _checkAndSanitizeMongoID = (idValue, validator, callback) ->
        if validator.isNull(idValue)
            nullIDError = new Error "Error! the id value is null"
            callback nullIDError, null
        else if validator.isMongoId(idValue)
            callback null, validator.trim(idValue)
        else
            invalidIDError = new Error "Error! Invalid ID"
            callback invalidIDError, null

    _checkAndSanitizeID = (idValue, fieldName, validator, callback) ->
        if validator.isNull(idValue) or not validator.isAlphanumeric(idValue)
            invalidIDError = new Error "Error! the #{fieldName} is invalid"
            callback invalidIDError, null
        else
            callback null, validator.trim(idValue)

    _checkAndSanitizeDecimal = (numberValue, fieldName, validator, callback) ->
        if validator.isNull(numberValue) or not validator.isDecimal(numberValue)
            invalidNumberError = new Error "Error! the #{fieldName} is an invalid decimal"
            callback invalidNumberError, null
        else
            callback null, numberValue

    _checkAndSanitizeWord = (wordData, token, validator, callback) ->
        if validator.isNull(wordData)
            nullWordError = new Error "Error! #{token} is null"
            callback nullWordError, null
        else if validator.isAlpha(wordData)
            callback null, validator.trim(wordData)
        else
            invalidWordError = new Error "Error! #{wordData} is not a valid #{token}"
            callback null, invalidWordError

    _checkAndSanitizeWords = (words, token, validator, callback) ->
        wordComponentError = undefined
        wordComponents = words.split " "
        validWordComponents = []
        for wordComponentItem in wordComponents
            do (wordComponentItem) =>
                if validator.isNull(wordComponentItem) or not validator.matches(wordComponentItem, /\w+/i)
                    wordComponentError = new Error "Error in #{token}! Invalid Word Component" unless wordComponentError?
                else
                    validWordComponents.push validator.trim(wordComponentItem)
        if wordComponentError?
            callback wordComponentError, null
        else if validWordComponents.length > 0
            callback null, validWordComponents.join(' ')
        else
            emptyWordError = new Error "Error! #{token} is empty"
            callback emptyWordError, null

    _checkAndSanitizeDate = (dateValue, validator, callback) ->
        if validator.isNull(dateValue) or not validator.isDate(dateValue)
            invalidDateError = new Error "Error! Invalid Date Value"
            callback invalidDateError, null
        else
            callback null, validator.trim(dateValue)

    _checkAndSanitizeNumber = (numberValue, fieldName, validator, callback) ->
        if validator.isNull(numberValue) or not validator.isNumeric(numberValue)
            invalidNumberError = new Error "Error! the #{fieldName} is an invalid number"
            callback invalidNumberError, null
        else
            callback null, numberValue

    constructor: ->

    checkAndSanitizeWord: (wordData, token, validator, callback) =>
        _checkAndSanitizeWord.call @, wordData, token, validator, (wordError, validWord) =>
            callback wordError, validWord

    checkAndSanitizeWords: (words, token, validator, callback) =>
        _checkAndSanitizeWords.call @, words, token, validator, (wordsError, validWords) =>
            callback wordsError, validWords

    checkAndSanitizeDecimal: (numberValue, fieldName, validator, callback) =>
        _checkAndSanitizeDecimal.call @, numberValue, fieldName, validator, (decimalError, validDecimal) =>
            callback decimalError, validDecimal

    checkAndSanitizeDate: (dateValue, validator, callback) =>
        _checkAndSanitizeDate.call @, dateValue, validator, (dateError, validDate) =>
            callback dateError, validDate

    checkAndSanitizeMongoID: (idValue, validator, callback) =>
        _checkAndSanitizeMongoID.call @, idValue, validator, (idValueError, validID) =>
            callback idValueError, validID

    checkAndSanitizeID: (idValue, fieldName, validator, callback) =>
        _checkAndSanitizeID.call @, idValue, fieldName, validator, (idValueError, validID) =>
            callback idValueError, validID

    checkAndSanitizeNumber: (numberValue, fieldName, validator, callback) =>
        _checkAndSanitizeNumber.call @, numberValue, fieldName, validator, (numberError, validNumber) =>
            callback numberError, validNumber
