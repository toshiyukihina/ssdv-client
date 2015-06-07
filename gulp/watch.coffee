gulp = require('gulp')

paths = gulp.paths

gulp.task 'watch', ['inject'], ->
  gulp.watch [
    "#{paths.src}/{app,components}/**/*.coffee"
  ], ['coffee', 'inject']
  
  gulp.watch [
    "#{paths.src}/*.html"
    "#{paths.src}/{app,components}/**/*.less"
    #"#{paths.src}/{app,components}/**/*.js"
    'bower.json'
  ], ['inject']
