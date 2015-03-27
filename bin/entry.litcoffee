Écrit CLI
=========

The CLI interface for the Écrit publishing framework.

	fs = require 'fs-sync'

	done = (exitmsg) ->
		console.log exitmsg if exitmsg
		process.exit 0

	if fs.exists "#{__dirname}/#{process.argv[2]}.litcoffee"
		require("./#{process.argv[2]}")(done) 

	else
		console.log "Not a valid parameter. \n\n\t`ecrit [create|test] [args...]`"
