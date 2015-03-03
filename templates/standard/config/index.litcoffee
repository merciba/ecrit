Config
======

	module.exports = {
		sessionSecret : "<[randomToken]>"

		app_name: '<[name]>'
		app_host: '<[host]>'
		app_email: '<[email]>'

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

		mail: {
			service: '<[email_service]>',
			auth: {
				user: '<[email]>',
				pass: '<[email_password]>'
			}
		}

	}