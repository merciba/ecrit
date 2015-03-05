### Global Controller

	module.exports = (app) ->

		return {

###### `controllers.home.before_all`

Put things in here if you want them to happen before any other middleware.

			before_all: (req, res, next) ->
				app.log "#{req.method.green} #{req.originalUrl}"
				next()

###### `controllers.home.api`

Validates `api/` endpoints.

			api: (req, res, next) ->
				if req.session.api_token?
					next()
				else res.json { error: 'Unauthorized' }, 401

###### `controllers.home.set_config`

Sets the app's config. See [here](/source/models/Config.litcoffee) to view the config's schema.

			set_config: (req, res, next) ->
				if req.body.config?
					query = { app_id: app.data_config.app_id }

					app.models.config.update query, req.body.config, (err, config) ->
						res.json { error: err }, 500 if err
						app.config = config
						next()
				else
					res.json { error: "Invalid or Empty Request" }, 500

###### `controllers.home.configure_app_email`

Configures app's email address.

			configure_app_email: (req, res, next) ->
				if (app.isSetup() and app.config.app_auth_type is ('email' or 'two-factor')) or (not app.isSetup() and req.body.config.app_auth_type is ('email' or 'two-factor')) 
					
					email_service = if app.isSetup() then app.config.email_service else req.body.config.app_email_service
					app_email = if app.isSetup() then app.config.app_email else req.body.config.app_email
					app_email_password = if app.isSetup() then app.config.app_email_password else req.body.config.app_email_password

					if app_email_service and app_email and app_email_password
						app.postman = nodemailer.createTransport { service: app_email_service, auth: { user: app_email, pass: app_email_password } }
						next()

				else if (app.isSetup() and app.config.app_auth_type is 'phone') or (not app.isSetup() and req.body.app_auth_type is 'phone')
					next()
				else 
					res.json { error: "Invalid or Empty Email Credentials" }, 500

###### `controllers.home.configure_app_sms`

Configures app's SMS text-message functionality

			configure_app_sms: (req, res, next) ->
				if (app.isSetup() and app.config.app_auth_type is ('phone' or 'two-factor')) or (not app.isSetup() and req.body.config.app_auth_type is ('phone' or 'two-factor')) 
					
					sid = if app.isSetup() then app.config.app_twilio_sid else req.body.config.app_twilio_sid
					authToken = if app.isSetup() then app.config.app_twilio_authToken else req.body.config.app_twilio_authToken
					
					if sid and authToken
						app.sms = twilio sid, authToken
						app.sms.incomingPhoneNumbers.get (err, data) ->
							if err
								res.json { error: "Your app must have a Twilio phone number to provision for auth. Go to https://www.twilio.com/user/account/phone-numbers/incoming for more info." }, 500 
							else
								app.phone_number = data.incoming_phone_numbers[0].phone_number
								next()

				else if (app.isSetup() and app.config.app_auth_type is 'email') or (not app.isSetup() and req.body.config.app_auth_type is 'email')
					next()
				else
					res.json { error: "Invalid or Empty Twilio Credentials" }, 500

		}
