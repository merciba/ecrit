Home Controller
===============

	module.exports = (app) ->

		return {

## `beforeAll`

Put things in here if you want them to happen before any other middleware.

			before_all: (req, res, next) ->
				app.log "#{req.method.green} #{req.originalUrl}"
				next()

## `set_config`

Sets the app's config. See [here](/source/models/Config.litcoffee) to view the config's schema.

			set_config: (req, res, next) ->
				if req.body?
					query = { app_id: app.data_config.app_id }
					replacement = {}
					for key, value of app.models.config.attributes 
						replacement[key] = req.body[key] if req.body.hasOwnProperty key

					app.models.config.update query, replacement, (err, config) ->
						res.json { error: err }, 500 if err
						next()
				else
					res.json { error: "Invalid or Empty Request" }, 500

## `configure_app_email`

Configures app's email address.

			configure_app_email: (req, res, next) ->
				if req.body.app_email_service? and req.body.app_email? and req.body.app_email_password
					app.postman = nodemailer.createTransport { service: req.body.app_email_service, auth: { user: req.body.app_email, pass: req.body.app_email_password } }
				next()

## `configure_app_sms`

Configures app's SMS text-message functionality

			configure_app_sms: (req, res, next) ->
				if req.body.app_email_service? and req.body.app_email? and req.body.app_email_password
					app.sms = twilio config.twilio.sid, config.twilio.authToken
					app.sms.incomingPhoneNumbers.get (err, data) ->
						next { method: "controllers.home.configure_app_sms", error: err } if err
						app.error "Your app must have a Twilio phone number to provision for auth. Go to https://www.twilio.com/user/account/phone-numbers/incoming for more info." if err
						app.phone_number = data.incoming_phone_numbers[0].phone_number
						next()
				else 
					res.json { error: "Invalid or Empty Request" }, 500

		}
