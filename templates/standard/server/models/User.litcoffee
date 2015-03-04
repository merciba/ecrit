User Model
==========

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

			phone: {
				type: 'string'
				required: false
				unique: true
			}

			email: {
				type: 'string'
				required: false
				unique: true
			}

			password: {
				type: 'string'
				required: false
				password: true
			}

			token: {
				type: 'string'
				required: true
				unique: true
			}

			toJSON: () ->
				obj = @toObject()
				delete obj.token
				delete obj.password
				return obj

			full_name: () ->
				return "#{this.first_name} #{this.last_name}"

		}

		beforeCreate: (user, next) ->
			bcrypt.hash user.password, 10, (err, hash) ->
				return next err if err
				user.password = hash
				bcrypt.hash user.token, 10, (err, hash) ->
					return next err if err
					user.token = hash
					next()
			
	}