Auth Controller
===============

	validator = require 'validator'
	tokenGenerator = require 'random-token'

	module.exports = (app) ->

		return {

Validate `api/` endpoints.

			api: (req, res, next) ->
				if req.session.token?
					next()
				else res.json { error: 'Unauthorized' }, 401

Validate a new email address.

			validate_new_email: (req, res, next) ->
				req.body.verified = false
				if req.body.submitted
					validated = validator.isEmail req.body.submitted
					if validated?
						req.body.id = req.body.submitted
						delete req.body.submitted

						app.models.users.findOne { id: req.body.id }, (err, user) ->
							next() if not user
							res.json { error: "User already exists" } if user
					else
						res.json { error: "Email Not Valid" }, 500
				else
					res.json { error: "Email Not Valid" }, 500

Validate a new password.

			validate_new_password: (req, res, next) ->
				if req.body.id and req.body.password and req.body.password_confirm and (req.body.password is req.body.password_confirm) and req.body.password.match /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{4,8}$/
					next()
				else
					res.json { "Password Not Valid, must be 6-13 characters long, have one lower case letter, one upper case letter, one digit, and no spaces." }, 500

Send a verification email.

			send_verify_email: (req, res, next) ->
				if req.body.id
					req.body.token = tokenGenerator 16
						
					#TODO: Send Verification email
					mail = {
						from: "#{app.config.app_name} <#{app.config.email}>"
						to: req.body.id
						subject: 'Hello #{req.body.name}'
						text: 'Thanks for trying Écrit'
						html: "<h1>Thanks for trying #{app.config.app_name}!</h1> <p>Click <a href=\"http://#{app.config.app_host}/verify/#{req.body.token}\">here</a> to validate your account.</p>"
					}

					app.postman.sendMail mail, (error, result) ->
						res.json { error: error }, 500 if error
						console.log result.response
						next()

				else
					res.json { error: "Email Not Valid" }, 500

			verify_new_user: (req, res) ->
				if req.params.token
					app.models.users.findOne { token: req.params.token }, (err, user) ->
						user.verified = true
						app.models.users.update user 

		}