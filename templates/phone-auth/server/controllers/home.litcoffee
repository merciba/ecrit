Home Controller
===============

	module.exports = (app) ->

		return {

			beforeAll: (req, res, next) ->
				app.log "#{req.method.green} #{req.originalUrl}"
				next()

		}
