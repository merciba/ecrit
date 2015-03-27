#!/usr/bin/env node

require('coffee-script').register()
fs = require('fs-sync')
path = require('path')
pkg = require(path.join(__dirname, '../package.json'))

done = function (exitmsg) {
	if (exitmsg) console.log(exitmsg)
	process.exit(0)
}

if (process.argv[2][0] === '-') {
	switch (process.argv[2]) {
		case '-v':
			done("v"+pkg.version)
	}
}
else if (fs.exists(__dirname+"/"+process.argv[2]+".litcoffee")) require("./"+process.argv[2]+".litcoffee")(done) 
else console.log("Not a valid parameter. \n\n\t`ecrit [create|test] [args...]`")

