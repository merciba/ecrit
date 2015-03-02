HTTP Post
---------

	module.exports = (app) ->

		return {

			'/setup': [ app.controllers.auth.verify_new_phone, app.controllers.auth.send_auth_token, app.controllers.users.create_admin ]

			'/api/:model': [(req, res, next) ->
				app.models[req.params.model].create req.body, (err, model) ->
					return res.json { error: err }, 500 if err
					res.json model
				]

		}