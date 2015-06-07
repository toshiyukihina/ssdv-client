gulp = require('gulp')

paths = gulp.paths

$ = require('gulp-load-plugins')()

wiredep = require('wiredep').stream

gulp.task 'inject', ['styles'], ->
  injectStyles = gulp.src([
    "#{paths.tmp}/serve/{app,components}/**/*.css"
    "!#{paths.tmp}/serve/app/vendor.css"
  ], read: false)

  injectScripts = gulp.src([
    "#{paths.tmp}/serve/{app,components}/**/*.js"
    "!#{paths.src}/{app,components}/**/*.spec.js"
    "!#{paths.src}/{app,components}/**/*.mock.js"
  ]).pipe($.angularFilesort())

  injectOptions =
    ignorePath: [
      paths.src
      "#{paths.tmp}/serve"
    ]
    addRootSlash: false

  wiredepOptions =
    directory: 'bower_components'
    exclude: [
      /bootstrap\.js/
      /bootstrap\.css/
      /bootstrap\.css/
      /foundation\.css/
    ]

  gulp.src("#{paths.src}/*.html")
    .pipe($.inject(injectStyles, injectOptions))
    .pipe($.inject(injectScripts, injectOptions))
    .pipe(wiredep(wiredepOptions))
    .pipe(gulp.dest("#{paths.tmp}/serve"))
