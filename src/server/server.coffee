'use strict'

# #################################################
# This is the main class of the Web Server
# #################################################

# define an execution environment
execEnv = process.env.NODE_ENV || 'development'

# loading required packages
bodyParser     = require 'body-parser'
compress       = require 'compression'
cors           = require 'cors'
express        = require 'express'
http           = require 'http'
methodOverride = require 'method-override'
morgan         = require 'morgan'

DBManager = require('./util/db-manager').DBManager


dbConnectionErrorCallback = (dbError) ->
    console.log "There was an error connecting to the Mongo DB"

dbDisconnectedCallback = () ->
    console.log "Mongo DB disconnected..."

dbSuccessfulConnectionCallback = () ->
    # create the express application
    trackApp = express()

    # express configuration
    trackApp.use(compress())
    trackApp.use(bodyParser.urlencoded({extended: false}))
    trackApp.use(bodyParser.json())
    trackApp.use(methodOverride())
    trackApp.use(cors())

    # insert api routes
    require('./routes/sightings')(trackApp)
    require('./routes/topics')(trackApp)
    require('./routes/admins')(trackApp)
    require('./routes/descriptions')(trackApp)

    # creeate http server
    trackServer = http.createServer trackApp
    portNumber = 7483

    trackServer.listen portNumber, () ->
      console.log "Welcome to animal tracking application. Server now listening on port %d in mode %s", portNumber, trackApp.settings.env

DBManager.getInstance().connect execEnv, dbConnectionErrorCallback, dbDisconnectedCallback, dbSuccessfulConnectionCallback
