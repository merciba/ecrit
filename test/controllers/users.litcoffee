### Users Controller Test

Unit tests for the `users` controller. Any new methods added to `/server/controllers/users` should have matching tests here. 

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

	controller = require("../../factory/server/controllers/users")(app)

Begin tests.

	describe 'controllers.users', () ->

#### [create_new_user](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/users.litcoffee#create_new_user)
		
		it 'create_new_user', (done) ->

__Scenario One:__ `req.body.user` matches [User model](https://github.com/merciba/ecrit/blob/master/factory/server/models/User.litcoffee).  
__Should:__ Call `app.models.users.create` with identical query.
			
			scenario_one = () ->

				req.body.user = {
					id: 'id'
					first_name: 'Test'
				}
				app.models.users = {
					create: (query, next) ->
						query.id.should.equal 'id'
						query.first_name.should.equal 'Test'
						next null, query

					attributes: require('../../factory/server/models/User').attributes
				}

				controller.create_new_user req, res, scenario_two

__Scenario Two:__ `req.body.user` doesn't match [User model](https://github.com/merciba/ecrit/blob/master/factory/server/models/User.litcoffee).  
__Should:__ Call `app.models.users.create` with modified query.
			
			scenario_two = () ->
				req.user.should.exist
				req.body.user = {
					id: 'id'
					first_name: 'Test'
					not_in_schema: 'I am not in the user schema'
				}
				app.models.users = {
					create: (query, next) ->
						query.id.should.equal 'id'
						query.should.not.have.property 'not_in_schema'
						query.first_name.should.equal 'Test'
						next null, query
						
					attributes: require('../../factory/server/models/User').attributes
				}

				controller.create_new_user req, res, done

			scenario_one()

#### [validate_new_user](https://github.com/merciba/ecrit/blob/master/factory/server/controllers/users.litcoffee#create_new_user)
		
		it 'validate_new_user', (done) ->

__Scenario One:__   
__Should:__ 
			
			scenario_one = () ->
				done()

			scenario_one()