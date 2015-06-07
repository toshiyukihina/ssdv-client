gulp = require('gulp')

$ = require('gulp-load-plugins')()

browserSync = require('browser-sync')

paths = gulp.paths

# Downloads the selenium webdriver
gulp.task 'webdriver-update', $.protractor.webdriver_update

gulp.task 'webdriver-standalone', $.protractor.webdriver_standalone

runProtractor = (done) ->
  gulp.src("#{paths.e2e}/**/*.js")
    .pipe($.protractor.protractor(configFile: 'protractor.conf.js'))
    .on 'error', (err) ->
      # Make sure failed tests cause gulp to exit non-zero
      throw err
    .on 'end', ->
      # Close browser sync server
      browserSync.exit()
      done()

gulp.task 'protractor', ['protractor:src']
gulp.task 'protractor:src', ['serve:e2e', 'webdriver-update'], runProtractor
gulp.task 'protractor:dist', ['serve:e2e-dist', 'webdriver-update'], runProtractor
