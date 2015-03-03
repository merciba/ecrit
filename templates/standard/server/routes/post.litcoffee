HTTP Post
---------

	module.exports = (app) ->

		return {

			'/setup': [ app.controllers.auth.validate_new_email, app.controllers.auth.validate_new_password, app.controllers.auth.send_verify_email, app.controllers.users.create_admin ]

			'/api/:model': [(req, res, next) ->
				app.models[req.params.model].create req.body, (err, model) ->
					return res.json { error: err }, 500 if err
					res.json model
				]

		}