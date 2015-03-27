Global Controller Test
===

Unit tests for the `global` controller. Any new methods added to `/server/controllers/global` should have matching tests here. 

	fs = require 'fs'
	path = require 'path'
	colors = require 'colors'
	moment = require 'moment'
	testConfig = require '../config.json'

Create mock server objects to pass through the tests

	req = {}
	res = {}
	app = {
		dialog: (str) -> console.log str.green if testConfig.console
		log: (str) -> console.log "#{moment().format('D MMM YYYY H:mm:ss').bgMagenta.black}: #{"Info:".cyan} #{str.cyan}" if testConfig.console
		error: (str) -> throw new Error "#{moment().format('D MMM YYYY H:mm:ss').bgMagenta.black}: #{"Error:".red} #{str.red}" if testConfig.console
		warn: (str) -> console.warn "#{moment().format('D MMM YYYY H:mm:ss').bgMagenta.black}: #{"Warning:".yellow} #{str.yellow}" if testConfig.console
	}

Assign the controller

	controller = require("../../factory/server/controllers/global")(app)

Begin tests.

	describe 'controllers.global', () ->

[before_all](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/global.litcoffee#before_all)
---
		
		it 'before_all', (done) ->

__Scenario:__ Any  
__Should:__ Display the time, method and original URL if `ecrit test` is invoked with the `--console` flag.

			req.method = 'GET'
			req.originalUrl = 'http://test.com'
			controller.before_all req, res, done

[api](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/global.litcoffee#api)
---

		it 'api', (done) ->

__Scenario:__ req.session.api_token exists  
__Should:__ Callback

			req.session = {
				api_token: 'mock api token'
			}

			controller.api req, res, () ->

__Scenario:__ req.session.api_token does not exist.  
__Should:__ Call `res.json` with `{ error: "Unauthorized" }`

				delete req.session.api_token

				res.json = (json) ->
					console.log JSON.stringify json if testConfig.console
					done()
				
				controller.api req, res, done

[set_config](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/global.litcoffee#set_config)
---

		it 'set_config', (done) ->

			done()
