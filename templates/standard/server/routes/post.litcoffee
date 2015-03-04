HTTP Post
---------

	module.exports = (app) ->

		return {

			'/setup': [ app.controllers.auth.validate_new_user, app.controllers.home.configure_app_email, app.controllers.home.configure_app_sms, app.controllers.auth.send_verify_email, app.controllers.auth.send_verify_sms, app.controllers.users.create_user ]

			'/api/:model': [(req, res, next) ->
				query = {}
				for key, value of app.models[req.params.model].attributes 
					query[key] = req.body[key] if req.body.hasOwnProperty key

				app.models[req.params.model].create query, (err, model) ->
					return res.json { error: err }, 500 if err
					res.json model
				]

		}