Config Model
============

	bcrypt = require 'bcrypt'

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

			app_url: {
				type: 'string'
				required: false
				defaultsTo: 'http://localhost:1234'
			}

			app_email: {
				type: 'string'
				required: false
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