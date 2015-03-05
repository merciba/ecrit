Config Model
============

	module.exports = {

		identity: 'config'
		connection: 'mongo'

		attributes: {

			app_name: {
				type: 'string'
				required: true
				unique: true
			}

			app_id: {
				type: 'string'
				required: true
				unique: true
			}

			app_host: {
				type: 'string'
				required: false
				defaultsTo: 'localhost'
			}

			app_email: {
				type: 'string'
				required: true
			}

			app_email_password: {
				type: 'string'
				required: false
				password: true
			}

			app_email_service: {
				type: 'string'
				required: false
			}

			app_i18n_locales: {
				type: 'array'
				required: false
				defaultsTo: ['en']
			}

			app_twilio_sid: {
				type: 'string'
				required: false
			}

			app_twilio_authToken: {
				type: 'string'
				required: false
			}

			app_auth_type: {
				type: 'string'
				required: true
				in: ['email', 'phone', 'two-factor']
			}

			signup_email_text: {
				type: 'string'
				required: false
				defaultsTo: "Thanks for signing up to #{this.app_name}!"
			}

			signup_email_html: {
				type: 'string'
				required: false
				defaultsTo: "<h1>Thanks for signing up to #{this.app_name}!</h1>"
			}

			toJSON: () ->
				obj = @toObject()
				delete obj.app_email_password
				return obj

		}

		beforeCreate: (config, next) ->
			if config.app_email_password
				bcrypt.hash config.app_email_password, 10, (err, hash) ->
					return next err if err
					config.app_email_password = hash
					next()
			
	}