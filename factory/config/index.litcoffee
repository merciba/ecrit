Config
======

	pkg = require '../package.json'

	module.exports = {
		sessionSecret : Date()

		app_id: pkg.name

		app_url: 'http://localhost:9009'

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
					database: pkg.name
				}
			}

			defaults: {
				migrate: 'alter'
			}
		}

	}