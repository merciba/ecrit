#!/usr/bin/env node

require('coffee-script').register()
fs = require('fs-sync')

done = function (exitmsg) {
	if (exitmsg) console.log(exitmsg)
	process.exit(0)
}

if (fs.exists(__dirname+"/"+process.argv[2]+".litcoffee")) require("./"+process.argv[2]+".litcoffee")(done) 
else console.log("Not a valid parameter. \n\n\t`ecrit [create|test] [args...]`")

