Users Controller
================

	module.exports = (app) ->

		return {

## `create_user`

Creates a new user

			create_user: (req, res, next) ->
				query = {}
				for key, value of app.models.users.attributes 
					query[key] = req.body[key] if req.body.hasOwnProperty key

				if not app.isSetup?
					query.admin = true 
				
				app.models.users.create query, (err, model) ->
					return res.json { error: err }, 500 if err
					res.json model

		}