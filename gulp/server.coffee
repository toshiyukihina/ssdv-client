gulp = require('gulp')

paths = gulp.paths

util = require('util')

browserSync = require('browser-sync')

middleware = require('./proxy')

browserSyncInit = (baseDir, files, browser) ->
  browser = if browser? then 'default' else browser

  routes = null
  if baseDir is paths.src or (util.isArray(baseDir) and baseDir.indexOf(paths.src) isnt -1)
    routes =
      '/bower_components': 'bower_components'

  browserSync.instance = browserSync.init files,
    startPath: '/'
    server:
      baseDir: baseDir
      middleware: middleware
      routes: routes
    browser: browser

gulp.task 'serve', ['coffee', 'watch'], ->
  browserSyncInit [
    "#{paths.tmp}/serve"
    paths.src
  ], [
    "#{paths.tmp}/serve/{app,components}/**/*.css"
    "#{paths.src}/{app,components}/**/*.js"
    "#{paths.src}/src/assets/images/**/*"
    "#{paths.tmp}/serve/*.html"
    "#{paths.tmp}/serve/{app,components}/**/*.html"
    "#{paths.src}/{app,components}/**/*.html"
  ]

gulp.task 'serve:dist', ['build'], ->
  browserSyncInit(paths.dist)

gulp.task 'serve:e2e', ['coffee', 'inject'], ->
  browserSyncInit([
    "#{paths.tmp}/serve"
    paths.src
  ], null, [])

gulp.task 'serve:e2e-dist', ['build'], ->
  browserSyncInit(paths.dist, null, [])
