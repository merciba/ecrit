### Modules Controller Test

Unit tests for the `modules` controller. Any new methods added to `/server/controllers/modules` should have matching tests here. 

	fs = require 'fs'
	fs_sync = require 'fs-sync'
	path = require 'path'
	rimraf = require 'rimraf'
	colors = require 'colors'
	moment = require 'moment'
	chai = require 'chai'
	chai.should()
	testConfig = require '../config.json'

Create mock server objects to pass through the tests

	req = {
		params: {}
		body: {}
	}
	res = {}
	app = {
		dialog: (str) -> console.log str.green if testConfig.console
		log: (str) -> console.log str.cyan if testConfig.console
		error: (str) -> throw new Error str.red if testConfig.console
		warn: (str) -> console.warn "[Warning]".yellow, str.yellow if testConfig.console
		models: {}
		data_config: {}
	}

Assign the controller

	controller = require("../../factory/server/controllers/modules")(app)

Begin tests.

	describe 'controllers.modules', () ->

#### [sync_modules](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/models.litcoffee#sync_modules)
		
		it 'sync_modules', (done) ->

__Scenario One:__  `app.models.modules.find({})` returns one result, a test instance of a front-end Module.
__Should:__ Copy the `script` and `templates` strings into their own files in `browser/modules/` and `browser/templates/`, respectively.
			
			scenario_one = () ->
				scriptPath = path.join __dirname, "../../factory/browser/modules/test.litcoffee"
				templatesPath = path.join __dirname, "../../factory/browser/templates/test.litcoffee"

				app.models.modules = {
					find: (query, next) ->
						next null, [
							{
								name: 'test'
								script: "Test Script\n====\n\n\tconsole.log 'test'"
								templates: "Test Template\n====\n\n\tmodule.exports = {\n\n\t\texample: (data) ->\n\t\t\treturn \"<div>Test</div>\"\n\n\t}\n" 
							}
						]
				}

				cleanup = () ->
					done()
					###fs.stat scriptPath, (err) ->
						throw new Error err if err
						rimraf scriptPath, () ->
							fs.stat templatesPath, (err) ->
								throw new Error err if err
								rimraf templatesPath, done###

				controller.sync_modules req, res, cleanup

			scenario_one()