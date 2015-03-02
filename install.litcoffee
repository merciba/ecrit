Install
=======

Installs a fresh Écrit project in the target directory.

	gulp = require('gulp')
	es = require('event-stream')
	mkdir = require 'mkdirp'

	module.exports = (config, end) ->
		console.log config
		mkdir config.target, (err) ->
			end err if err
			console.log "Ready to install at #{config.target}"
		###gulp.src("./templates/#{config.template}")
		.pipe(gulp.dest(config.target)
			.on('end', () ->
				end()
			))###

