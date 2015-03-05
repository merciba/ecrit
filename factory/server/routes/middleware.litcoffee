Middleware
----------

	path = require 'path'

	module.exports = (app) ->

		return {

			'/': [ app.controllers.global.before_all ]

			'/js': [ app.bundle "server/public/scripts" ]

			'/api/*': [ app.controllers.global.api ]

		}