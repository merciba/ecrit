Auth Controller
===============

	phone = require 'phone'
	tokenGenerator = require 'random-token'

	module.exports = (app) ->

		return {

			api: (req, res, next) ->
				if req.session.token?
					next()
				else res.json { err: 'Unauthorized' }, 401

			verify_new_phone: (req, res, next) ->
				if req.body.submitted
					validated = phone req.body.submitted
					delete req.body.submitted
					if validated? and validated[0] and validated[1]
						req.body.id = validated[0]
						req.body.country = validated[1]

						app.models.users.findOne { id: req.body.id }, (err, user) ->
							next() if not user
							console.log user if user
					else
						res.json { error: "Not Valid" }
				else
					res.json { error: "Not Valid" }

			send_auth_token: (req, res, next) ->
				if req.body.id and req.body.country
					tokenConfirm = tokenGenerator.create('0123456789')(6)
						
					app.sms.messages.create { to: req.body.id, from: app.phone_number, body: "Your auth token is #{tokenConfirm}" }, (err, message) ->
						if err
							res.json { error: err }, 500 
						req.body.token = tokenConfirm
						next()
				else
					res.json { error: "Not Valid" }

		}