var gulp = require('gulp'),
	nodemon = require('gulp-nodemon'),
	coffee = require('gulp-coffee'),
	colors = require('colors');

gulp.task('build', function() {
	gulp.src('browser/**/*.litcoffee')
		.pipe(coffee({literate: true})).on('error', console.error)
		.pipe(gulp.dest('server/public/scripts/')).on('end', function() {
			console.log("[Écrit] Done rebuilding /js/build.".green)
		})
})

gulp.task('prod', function() {
    gulp.watch('browser/**/*.litcoffee', ['build']).on('change', function(event) {
    	console.log('[Écrit] [Info] '.cyan + event.path.cyan + ' was '.cyan + event.type.cyan + '. Rebuilding /js/build...'.cyan)
    })
    require('./index.js')
})

gulp.task('default', ['prod']);
gulp.start();