Config
======

	module.exports = {
		sessionSecret : Date()

		app_id: 'factory'

		app_url: 'http://localhost:9000'

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
					database: 'factory'
				}
			}

			defaults: {
				migrate: 'alter'
			}
		}

	}