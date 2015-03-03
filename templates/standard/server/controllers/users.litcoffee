Users Controller
================

	module.exports = (app) ->

		return {

			create_admin: (req, res, next) ->
				req.body.admin = true
				console.log req.body
				app.models.users.create req.body, (err, model) ->
					return res.json { error: err }, 500 if err
					res.json model

		}