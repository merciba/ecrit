### Users Controller

	phone = require 'phone'
	validator = require 'validator'
	tokenGenerator = require 'random-token'

	module.exports = (app) ->

		return {

###### `controllers.users.create_new_user`

Creates a new user

			create_new_user: (req, res, next) ->
				query = {}
				for key, value of app.models.users.attributes 
					query[key] = req.body[key] if req.body.users.hasOwnProperty key

				if not app.isSetup()
					query.admin = true 
				
				app.models.users.create query, (err, model) ->
					return res.json { error: err }, 500 if err
					next null, model

###### `controllers.users.validate_new_user`

Validates a new email address via `POST`

			validate_new_user: (req, res, next) ->
				req.body.user.verified = false
				if req.body.user.id
					isEmail = validator.isEmail req.body.user.id
					isPhone = phone req.body.user.id
					
					if isEmail? 
						if (app.isSetup() and app.config.app_auth_type is ('email' or 'two-factor')) or (not app.isSetup() and req.body.config.app_auth_type is ('email' or 'two-factor'))
							req.body.user.email = req.body.submitted
						else
							res.json { error: "User ID/Auth Type mismatch" }, 500
					else if isPhone?
						if (app.isSetup() and app.config.app_auth_type is 'phone') or (not app.isSetup() and req.body.config.app_auth_type is 'phone')
							req.body.user.id = isPhone[0]
							req.body.user.phone = isPhone[0]
							req.body.user.country = isPhone[1]
						else
							res.json { error: "User ID/Auth Type mismatch" }, 500
					else
						res.json { error: "User ID/Auth Type mismatch" }, 500

					delete req.body.submitted

					# Make sure the user doesn't already exist
					query = { id: req.body.user.id }
					app.models.users.findOne query, (err, user) ->
						if user and Object.keys(user).length
							res.json { error: "User already exists" }, 500
						else
							# Make sure the password is valid
							if req.body.user.email and req.body.user.password and req.body.user.password_confirm
								if (req.body.user.password is req.body.user.password_confirm) and req.body.user.password.match /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/
									next()
								else
									res.json { error: "Password Not Valid, must be at least 8 characters long, have one lower case letter, one upper case letter, one digit, one special character, and no spaces." }, 500
							else if req.body.user.phone and req.body.user.country
								next()

				else
					res.json { error: "Not Valid" }, 500

###### `controllers.users.send_verify_sms`

Sends a verification SMS via `POST`

			send_verify_sms: (req, res, next) ->
				if req.body.user.phone? and app.sms?
					req.body.user.phone_token = tokenGenerator.create('0123456789')(6)
						
					app.sms.messages.create { to: req.body.user.id, from: app.phone_number, body: "Your #{app.config.app_name} auth token is #{req.body.user.phone_token}" }, (err, message) ->
						if err
							res.json { error: err }, 500 
						else
							next()

				else if app.config.app_auth_type is 'email'
					next()
				else
					res.json { error: "Not Valid or Not Configured" }

###### `controllers.users.send_verify_email`

Sends a verification email via `POST`

			send_verify_email: (req, res, next) ->
				if app.postman? and req.body.user.email
					req.body.user.token = tokenGenerator 24

					mail = {
						from: "#{app.config.app_name} <#{app.config.app_email}>"
						to: req.body.user.email
						subject: 'Hello #{req.body.user.first_name}'
						text: app.config.signup_email_text
						html: "#{app.config.signup_email_html} <p>Click <a href=\"http://#{app.config.app_host}/verify/#{req.body.user.token}\">here</a> to validate your account and finish setting up your app, #{app.config.app_name}.</p>"
					}

					app.postman.sendMail mail, (err, result) ->
						if err
							res.json { error: err }, 500 
						else
							next()

				else if app.config.app_auth_type is 'phone'
					next()
				else
					res.json { error: "App Email Not Valid or Not Configured" }, 500

###### `controllers.users.verify_token`

Verifies a token sent via a `GET` to `/verify/:token` or a `POST` to `/verify` with `user.phone_token`

			verify_token: (req, res, next) ->
				if req.params.token?
					query = { token: req.params.token }
					replacement = { verified: true }
					app.models.users.update query, replacement, (err, user) ->
						if err
							res.render 'error', { error: err }
						else
							res.render 'verified', query
				else if req.body.user.id and req.body.user.phone_token
					query = { phone_token: req.body.user.token }
					replacement = { verified: true }
					app.models.users.update query, replacement, (err, user) ->
						if err
							res.json { error: err }, 500
						else
							res.json { status: "ok" }, 200

###### `controllers.users.email_login`

Logs a user in with email/password.

			email_login: (req, res, next) ->
				if req.body.user.id and ((app.config.app_auth_type is 'email' or 'two-factor') and req.body.user.password)
					app.models.users.findOne { id: req.body.user.id }, (err, user) ->
						if err
							res.json { error: err } 
						else if user and user.login req.body.user.password
							next()
						else if not user
							res.json { error: "User Doesn't Exist" }, 500
						else if not user.login req.body.user.password
							res.json { error: "Invalid Credentials" }, 500
				else if app.config.app_auth_type is 'email' or 'two-factor'
					res.json { error: "Invalid Credentials"}, 500
				else
					next()

###### `controllers.users.phone_login`

Logs a user in with phone/token.

			phone_login: (req, res, next) ->
				if req.body.user.id and ((app.config.app_auth_type is 'phone' or 'two-factor') and req.body.user.phone_token)
					
					app.models.users.findOne { id: req.body.user.id }, (err, user) ->
						if err
							res.json { error: err } 
						else if user and user.phoneLogin req.body.user.phone_token
							next()
						else if not user
							res.json { error: "User Doesn't Exist" }, 500
						else if not user.login req.body.user.token
							res.json { error: "Invalid Credentials" }, 500
				else if app.config.app_auth_type is 'phone' or 'two-factor'
					res.json { error: "Invalid Credentials"}, 500
				else
					next()

		}