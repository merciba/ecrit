Config
======

	module.exports = {
		sessionSecret : "<[randomToken]>"

		name: '<[name]>'

		data: {

			adapters: {
				default: require 'sails-mongo'
				mongo: require 'sails-mongo'
			}

			connections: {
				mongo: {
					adapter: 'mongo'
					host: '<[mongo_host]>',
					port: 27017,
					user: '<[mongo_user]>',
					password: '<[mongo_password]>',
					database: '<[name]>'
				}
			}

			defaults: {
				migrate: 'alter'
			}
		}

		i18n: {
			locales: ['en']
			language: 'en'
		}

		twilio: {
			sid: '<[twilio_sid]>'
			authToken: '<[twilio_auth_token]>'
		}

	}