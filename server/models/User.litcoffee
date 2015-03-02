Models
======

	phone = require 'phone'
	bcrypt = require 'bcrypt'

	module.exports = {

		identity: 'users'
		connection: 'mongo'

		attributes: {

			id: {
				type: 'string'
				required: true
				unique: true
			}

			admin: {
				type: 'boolean'
				defaultsTo: false
			}

			country: {
				type: 'string'
				required: true
			}

			token: {
				type: 'string'
				required: true
				unique: true
			}

			toJSON: () ->
				obj = @toObject()
				delete obj.token
				return obj

			full_name: () ->
				return "#{this.first_name} #{this.last_name}"

		}

		beforeCreate: (user, next) ->
			bcrypt.hash user.token, 10, (err, hash) ->
				return next err if err
				user.token = hash
				next()
			
	}