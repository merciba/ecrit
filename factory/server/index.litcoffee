Écrit
=====

Publishing for cool people.

	Ecrit  = (port) ->

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
		passport 		= require 'passport'

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

Re-route console methods to app, so that we can control language translation and put a timestamp on output

			app.dialog = (str) -> console.log "[#{data_config.app_id}]".magenta, str.green
			app.log = (str) -> console.log "[#{data_config.app_id}]".magenta, "[Info]".cyan, str.cyan
			app.error = (str) -> throw new Error str.red
			app.warn = (str) -> console.warn "[#{data_config.app_id}]".magenta, "[Warning]".yellow, str.yellow

			app.models = dbModels.collections
			app.connections = dbModels.connections
			app.log "Database Connected"
			app.data_config = data_config
			app.isSetup = () -> return app.hasOwnProperty('config')

Check for an installed app in the db

			app.models.config.findOne { app_id: app.data_config.app_id }, (err, config) ->
				app.error err if err

				if config and Object.keys(config).length
					app.config = config

Configure i18n locales.
					
					if app.config.app_i18n_locales
						i18n.configure {
							locales: app.config.app_i18n_locales
							defaultLocale: 'en'
							directory: './config/i18n/locales'
						}
						app.__ = i18n.__

Configure SMS functionality using [Twilio](http://twilio.com)

					if app.config.app_twilio_sid and app.config.app_twilio_authToken and app.config.app_auth_type is ('phone' or 'two-factor')
						app.sms = twilio app.config.twilio.sid, app.config.twilio.authToken
						app.sms.incomingPhoneNumbers.get (err, data) ->
							app.error "Your app must have a Twilio phone number to provision for auth. Go to https://www.twilio.com/user/account/phone-numbers/incoming for more info." if err
							app.phone_number = data.incoming_phone_numbers[0].phone_number

					if app.config.app_email_service and app.config.app_email and app.config.app_email_password and app.config.app_auth_type is ('email' or 'two-factor')
						app.postman = nodemailer.createTransport { service: app.config.app_email_service, auth: { user: app.config.app_email, pass: app.config.app_email_password } }
						app.dialog "Email configured."
				
				else
					app.warn "First install, additional setup required"
					app.__ = (str) -> return str

Set the TCP/IP port for the app to listen on. During development it's set at `localhost:1234` 
but it can be any number that isn't already used by any other system software (such as mongodb, which rests on `localhost:27017`).

				app.set 'port', port or process.env.PORT or 9090

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

Configure Passport

				passport.serializeUser (user, done) ->
					done(null, user.id)

				passport.deserializeUser (id, done) ->
					app.models.users.findById id, (err, user) ->
						done(err, user)

Configure middleware and REST routes

				app.use.apply app, [route].concat methods for route, methods of routes.middleware app
				app.get.apply app, [route].concat methods for route, methods of routes.get app
				app.post.apply app, [route].concat methods for route, methods of routes.post app
				app.put.apply app, [route].concat methods for route, methods of routes.put app
				app.delete.apply app, [route].concat methods for route, methods of routes.delete app

Start the server.

				server = require('http').createServer app
				server.listen app.get("port"), () ->
					console.log " ==================================================================\n
								|\t\t\t\t  n  \t\t\t\t  |\n
								|\t\t\t\t.|||.\t\t\t\t  |\n
								|\t\t\t\t| | |\t\t\t\t  |\n
								|\t\t\t\t| | |\t\t\t\t  |\n
								|\t\t\t\t| | |\t\t\t\t  |\n
								|\t\t\t\t| O |   Un cadre                  |\n
								|\t\t\t\t|   |   d'application             |\n
								|\t\t\t\t|___|   trop entêté.              |\n
								|\t\t\t\t(   )\t\t\t\t  |\n
								|\tÉcrit\t\t\t|   |\t\t\t\t  |\n
								|\t------------------------|   |\t\t\t\t  |\n
								|\t   ---------------------|   |   An extremely              |\n
								|\t      ------------------|   |   opinionated               |\n
								|\t\t ---------------|   |   app framework.            |\n
								|\t\t    ------------'.-.'\t\t\t\t  |\n
								|\t\t       --------- ) ( \t\t\t\t  |\n
								|\t\t\t  ------(   )\t\t\t\t  |\n
								|\t\t\t     --- \\|/ \t\t\t\t  |\n
								|\t\t\t\t  '  \t\t\t\t  |\n
								==================================================================".magenta
					console.log "[#{app.data_config.app_id}]".magenta, "v#{pkg.version.cyan} #{app.__('on')} #{ip.address().blue}:#{app.get('port').toString().red}"

		@

	module.exports = Ecrit