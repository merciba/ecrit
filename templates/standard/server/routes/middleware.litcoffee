Middleware
----------

	path = require 'path'

	module.exports = (app) ->

		return {

			'/': [ app.controllers.home.beforeAll ]

			'/js': [ app.bundle "server/public/scripts" ]

			'/api/*': [ app.controllers.auth.api ]

		}