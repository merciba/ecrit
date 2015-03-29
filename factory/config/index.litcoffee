Config
======

	pkg = require '../package.json'
	randomToken = require 'random-token'

	module.exports = {
		sessionSecret: randomToken 16

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