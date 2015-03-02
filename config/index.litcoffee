Config
======

	module.exports = {
		sessionSecret : "<Your Session Secret>"

		name: 'My Écrit Blog'

		data: {

			adapters: {
				default: require 'sails-mongo'
				mongo: require 'sails-mongo'
			}

			connections: {
				mongo: {
					adapter: 'mongo'
					host: 'localhost',
					port: 27017,
					user: '',
					password: '',
					database: 'ecrit'
				}
			}

			defaults: {
				migrate: 'alter'
			}
		}

		i18n: {
			locales: ['en', 'fr']
			language: 'en'
			apiKey: '<Google Translate API Key>'
		}

		twilio: {
			sid: '<Twilio SID>'
			authToken: '<Twilio Auth Token>'
		}

	}
