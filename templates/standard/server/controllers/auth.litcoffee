Auth Controllers
================

	validator = require 'validator'
	tokenGenerator = require 'random-token'

	module.exports = (app) ->

		return {

Validates `api/` endpoints.

			api: (req, res, next) ->
				if req.session.api_token?
					next()
				else res.json { error: 'Unauthorized' }, 401

Validates a new email address.

			validate_new_user: (req, res, next) ->
				req.body.verified = false
				if req.body.submitted
					isEmail = validator.isEmail req.body.submitted
					isPhone = phone req.body.submitted
					
					if isEmail?
						req.body.user_id_format = 'email'
						req.body.id = req.body.submitted
						req.body.email = req.body.submitted
					else if isPhone?
						req.body.user_id_format = 'phone'
						req.body.id = isPhone[0]
						req.body.phone = isPhone[0]
						req.body.country = isPhone[1]
					else
						res.json { error: "Not Valid" }, 500

					delete req.body.submitted

					# Make sure the user doesn't already exist
					query = { id: req.body.id }
					app.models.users.findOne query, (err, user) ->
						if user
							res.json { error: "User already exists" }, 500 if user
						else
							# Make sure the password is valid
							if req.body.id and req.body.password and req.body.password_confirm and (req.body.password is req.body.password_confirm) and req.body.password.match /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{4,8}$/
								next()
							else
								res.json { error: "Password Not Valid, must be 6-13 characters long, have one lower case letter, one upper case letter, one digit, and no spaces." }, 500
				else
					res.json { error: "Not Valid" }, 500

Sends a verification SMS

			send_verify_sms: (req, res, next) ->
				if req.body.phone and app.sms?
					req.body.token = tokenGenerator.create('0123456789')(6)
						
					app.sms.messages.create { to: req.body.id, from: app.phone_number, body: "Your auth token is #{tokenConfirm}" }, (err, message) ->
						if err
							res.json { error: err }, 500 
						req.body.token = tokenConfirm
						next()
				else
					res.json { error: "Not Valid or Not Configured" }

Sends a verification email.

			send_verify_email: (req, res, next) ->
				if req.body.email and app.postman?
					req.body.token = tokenGenerator 24
						
					mail = {
						from: "#{app.config.app_name} <#{app.config.app_email}>"
						to: req.body.id
						subject: 'Hello #{req.body.name}'
						text: 'Thanks for trying Écrit!'
						html: "<h1>Thanks for trying #{app.config.app_name}!</h1> <p>Click <a href=\"http://#{app.config.app_host}/verify/#{req.body.token}\">here</a> to validate your account.</p>"
					}

					app.postman.sendMail mail, (err, result) ->
						res.json { error: err }, 500 if error
						console.log result.response
						next()

				else
					res.json { error: "App Email Not Valid or Not Configured" }, 500

Verifies a token sent via a `POST` to `/verify/:token`

			verify_token: (req, res, next) ->
				if req.params.token
					query = { token: req.params.token }
					replacement = { verified: true }
					app.models.users.update query, replacement, (err, user) ->
						if err
							res.render 'error', { error: err } 
						else
							app.isSetup = true
							res.render 'verified', query

		}