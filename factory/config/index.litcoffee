Config
======

	pkg = require '../package.json'
	randomToken = require 'random-token'

	module.exports = {
		sessionSecret: randomToken 16

		app_id: pkg.name

		app_url: 'http://ÉNV:app_host'

		data: {

			adapters: {
				default: require 'sails-mongo'
				mongo: require 'sails-mongo'
			}

			connections: {
				mongo: {
					adapter: 'mongo'
					host: "ÉNV:mongo_host",
					port: 27017,
					user: "ÉNV:mongo_user",
					password: "ÉNV:mongo_password",
					database: pkg.name
				}
			}

			defaults: {
				migrate: 'alter'
			}
		}

	}