### Global Controller Test

Unit tests for the `global` controller. Any new methods added to `/server/controllers/global` should have matching tests here. 

	fs = require 'fs'
	path = require 'path'
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

	controller = require("../../factory/server/controllers/global")(app)

Begin tests.

	describe 'controllers.global', () ->

#### [before_all](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/global.litcoffee#before_all)
		
		it 'before_all', (done) ->

__Scenario:__ Any  
__Should:__ Display the time, method and original URL if `ecrit test` is invoked with the `--console` flag.
			
			scenario_one = () ->

				req.method = 'GET'
				req.originalUrl = 'http://test.com'

				controller.before_all req, res, done

			scenario_one()


#### [api](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/global.litcoffee#api)

		it 'api', (done) ->

__Scenario:__ req.session.api_token exists  
__Should:__ Callback

			scenario_one = () ->

				req.session = {
					api_token: 'mock api token'
				}

				controller.api req, res, scenario_two

__Scenario:__ req.session.api_token does not exist.  
__Should:__ Call `res.json` with `{ error: "Unauthorized" }`  

			scenario_two = () ->

				delete req.session.api_token

				res.json = (json) ->
					console.log JSON.stringify json if testConfig.console
					json.should.have.property "error"
					json.error.should.equal "Unauthorized"
					done()
				
				controller.api req, res, done

			scenario_one()

#### [set_config](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/global.litcoffee#set_config)

		it 'set_config', (done) ->

__Scenario:__ `app.isSetup()` returns `true`  
__Should:__ Update `app.config` with `replace_me: 'replacement'`

			scenario_one = () ->

				req.body.config = { test_key: 'test value', replace_me: 'replacement' }
				app.data_config = { app_id: 'app_id', app_url: 'app_url' }
				app.isSetup = () -> return true
				app.config = { app_id: 'app_id', app_url: 'app_url', test_key: 'test_value', replace_me: 'replace me' }
				app.models.config = { 
					update: (query, replacement, next) ->
						app.config.replace_me.should.equal 'replace me'
						query.app_id.should.equal replacement.app_id
						next null, replacement
				}

				next = () ->
					app.config.replace_me.should.equal 'replacement'
					scenario_two()

				controller.set_config req, res, next

__Scenario:__ `app.isSetup()` returns `false`  
__Should:__ Update `app.config` with `replace_me: 'replacement'`

			scenario_two = () ->
				
				app.isSetup = () -> return false
				app.config = undefined
				app.models.config = { 
					create: (object, next) ->
						object.replace_me.should.equal 'replacement'
						next null, object
				}

				next = () ->
					app.config.replace_me.should.equal 'replacement'
					done()

				controller.set_config req, res, next

			scenario_one()

#### [configure_app_email](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/global.litcoffee#configure_app_email)<sup>[*](#note)</sup>

		it 'configure_app_email', (done) ->

__Scenario:__ `app.isSetup()` returns `true` and `app.config.app_auth_type` is `'email'`
__Should:__ Create `app.postman`, an instance of [Nodemailer](http://adilapapaya.com/docs/nodemailer/).

			scenario_one = () ->

				app.postman = {}

				next = () ->
					app.postman.should.be.empty

				controller.set_config req, res, next

				done()

			scenario_one()

#### Note
<sup>*</sup>This particular test is more of a filler test for consistency's sake, it doesn't really do anything useful.
