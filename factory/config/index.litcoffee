Config
======

	module.exports = {
		sessionSecret : Date()

		app_id: '<[app_id]>'

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
					database: '<[app_id]>'
				}
			}

			defaults: {
				migrate: 'alter'
			}
		}

	}