Écrit
=====

Publishing for cool people.

	Ecrit  = () ->

Here's where we require our [npm modules](https://npmjs.com). Everything specified in `package.json` is usually instantiated here.

		express 		= require 'express'
		moment 			= require 'moment'
		path 			= require 'path'
		fs				= require 'fs'
		ip 				= require 'ip'
		colors 			= require 'colors'
		bodyParser 		= require 'body-parser'
		cookieParser 	= require 'cookie-parser'
		favicon			= require 'express-favicon'
		session			= require 'express-session'
		compression 	= require 'compression'
		request 		= require 'request'
		eventstream 	= require 'event-stream'
		Waterline		= require 'waterline'
		browserify 		= require 'browserify-middleware'
		i18n			= require 'i18n'
		nodemailer 		= require 'nodemailer'
		twilio 			= require 'twilio'

Require local files as modules. Note the relative paths.

		data_config		= require '../config'
		pkg				= require '../package.json'

Load the models, routes, and controllers from their directories in `server/models/`, `server/routes/`, and `server/controllers/`, respectively. 

		models			= {}
		routes 			= {}
		controllers		= {}

		models[model.replace('.litcoffee', '')] = require("./models/#{model.replace('.litcoffee', '')}") for model in fs.readdirSync(path.join(__dirname, "models"))
		routes[route.replace('.litcoffee', '')] = require("./routes/#{route.replace('.litcoffee', '')}") for route in fs.readdirSync(path.join(__dirname, "routes"))
		controllers[controller.replace('.litcoffee', '')] = require("./controllers/#{controller.replace('.litcoffee', '')}") for controller in fs.readdirSync(path.join(__dirname, "controllers"))

Configure database.

		orm = new Waterline()
		orm.loadCollection Waterline.Collection.extend model for name, model of models

		orm.initialize data_config.data, (err, dbModels) ->
			throw err if err

Instantiate the global `app` object. `app` will contain the main [Express](http://expressjs.com/) server instance, as well as other properties we can add as we see fit. 

			app	= express()

			app.models = dbModels.collections
			app.connections = dbModels.connections
			app.dialog "Database Connected"
			app.data_config = data_config

Re-route console methods to app, so that we can control language translation and put a timestamp on output

			app.dialog = (str) -> console.log str.green
			app.log = (str) -> console.log "#{moment().format('D MMM YYYY H:mm:ss').bgMagenta.black}: #{"Info:".cyan} #{str.cyan}"
			app.error = (str) -> throw new Error "#{moment().format('D MMM YYYY H:mm:ss').bgMagenta.black}: #{"Error:".red} #{str.red}"
			app.warn = (str) -> console.warn "#{moment().format('D MMM YYYY H:mm:ss').bgMagenta.black}: #{"Warning:".yellow} #{str.yellow}"

Check for an installed app in the db

			app.models.config.findOne { app_id: app.data_config.app_id }, (err, config) ->
				app.error err if err

				if config and Object.keys(config).length
					app.isSetup = true
					app.config = config

Configure i18n locales.
					
					if config.app_i18n_locales
						i18n.configure {
							locales: config.i18n.locales
							defaultLocale: 'en'
							directory: './config/i18n/locales'
						}
						__ = i18n.__
						app.use i18n.init

Configure SMS functionality using [Twilio](http://twilio.com)

					if config.app_twilio_sid and config.app_twilio_authKey
						app.sms = twilio config.twilio.sid, config.twilio.authToken
						app.sms.incomingPhoneNumbers.get (err, data) ->
							app.error "Your app must have a Twilio phone number to provision for auth. Go to https://www.twilio.com/user/account/phone-numbers/incoming for more info." if err
							app.phone_number = data.incoming_phone_numbers[0].phone_number
				
				else
					app.dialog "First install, additional setup required"
					app.isSetup = false
					__ = (str) -> return str

Set the TCP/IP port for the app to listen on. During development it's set at `localhost:1234` 
but it can be any number that isn't already used by any other system software (such as mongodb, which rests on `localhost:27017`).

				app.set 'port', process.env.PORT or 1234

Set the view engine. Écrit uses [Jade](http://jade-lang.com/) by default.

				app.set 'views', "#{__dirname}/views"
				app.set 'view engine', 'jade'

Configure [Browserify](http://browserify.org/) settings. 

				app.bundle = browserify
				app.bundle.settings { 
					precompile: true
					#cache: true 
				}

Attach all to the Express instance.

				app.use express.static "#{__dirname}/public"
				app.use compression()
				app.use cookieParser()
				app.use favicon "#{__dirname}/public/img/favicon.ico"
				app.use session { secret: app.data_config.sessionSecret, cookie: { maxAge: 3600000 } }
				app.use bodyParser.json()
				app.use bodyParser.urlencoded { extended: true }

Attach controllers.

				app.controllers = {}

				for category, list of controllers
					app.controllers[category] = {}
					app.controllers[category][name] = controller for name, controller of list app

Configure middleware and REST routes

				app.use.apply app, [route].concat methods for route, methods of routes.middleware app
				app.get.apply app, [route].concat methods for route, methods of routes.get app
				app.post.apply app, [route].concat methods for route, methods of routes.post app
				app.put.apply app, [route].concat methods for route, methods of routes.put app
				app.delete.apply app, [route].concat methods for route, methods of routes.delete app
				app.use.apply app, [route].concat methods for route, methods of routes.error app

Start the server.

				server = require('http').createServer app
				server.listen app.get("port"), () ->
					console.log "#{"Powered By Écrit".bgMagenta.black}: id = #{app.data_config.app_id.cyan} (#{__('version')} #{pkg.version.cyan}) #{__('on')} #{ip.address().blue}:#{app.get('port').toString().red}"

		@

	module.exports = Ecrit