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
				required: false
				unique: true
			}

			verified: {
				type: 'boolean'
				defaultsTo: false
			}

			phone_token: {
				type: 'string'
				required: false
				unique: true
			}

			first_name: {
				type: 'string'
				required: true
			}

			last_name: {
				type: 'string'
				required: false
			}

			toJSON: () ->
				obj = @toObject()
				delete obj.password
				return obj

			full_name: () ->
				return "#{this.first_name} #{this.last_name}"

			login: (password) ->
				return bcrypt.compareSync password, @password

			phoneLogin: (phone_token) ->
				return (phone_token is @phone_token) 

		}

		beforeCreate: (user, next) ->
			bcrypt.hash user.password, 10, (err, hash) ->
				next err if err
				user.password = hash
				next()

		beforeUpdate: (user, next) ->
			if user.new_password?
				bcrypt.genSalt 10, (err, salt) ->
					next err if err
					bcrypt.hash user.new_password, salt, (err, encrypted) ->
						next err if err
						delete user.new_password
						user.password = encrypted
						next()
			
	}