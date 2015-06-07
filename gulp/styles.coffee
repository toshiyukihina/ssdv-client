gulp = require('gulp')

paths = gulp.paths

$ = require('gulp-load-plugins')()

gulp.task 'styles', ->
  lessOptions =
    paths: [
      'bower_components'
      "#{paths.src}/app"
      "#{paths.src}/components"
    ]

  injectFiles = gulp.src([
    "#{paths.src}/{app,components}/**/*.less"
    "!#{paths.src}/app/index.less"
    "!#{paths.src}/app/vendor.less"
  ], read: false)

  injectOptions =
    transform: (filePath) ->
      filePath = filePath.replace("#{paths.src}/app/", '')
      filePath = filePath.replace("#{paths.src}/components/", '../components/')
      "@import \'#{filePath}\'"
    starttag: '// injector'
    endtag: '// endinjector'
    addRootSlash: false

  indexFilter = $.filter('index.less')

  gulp.src [
    "#{paths.src}/app/index.less"
    "#{paths.src}/app/vendor.less"
  ]
  .pipe(indexFilter)
  .pipe($.inject(injectFiles, injectOptions))
  .pipe(indexFilter.restore())
  .pipe($.less())
  .pipe($.autoprefixer())
  .on 'error', (err) ->
    console.error(err.toString())
    @emit('end')
  .pipe(gulp.dest("#{paths.tmp}/serve/app/"))
