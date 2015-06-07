gulp = require('gulp')

$ = require('gulp-load-plugins')()

wiredep = require('wiredep')

paths = gulp.paths

runTests = (singleRun, done) ->
  bowerDeps = wiredep(
    directory: 'bower_components'
    exclude: ['bootstrap-sass-official']
    dependencies: true
    devDependencies: true
  )

  testFiles = bowerDeps.js.concat([
    "#{paths.src}/{app,components}/**/*.js"
  ])

  gulp.src(testFiles)
    .pipe($.karma(
      configFile: 'karma.conf.js'
      action: (singleRun)? 'run': 'watch'
    ))
    .on 'error', (err) ->
      # Make sure failed tests cause gulp to exit non-zero
      throw err

gulp.task 'test', (done) ->
  runTests(true, done)
  
gulp.task 'test:auto', (done) ->
  runTests(false, done)
