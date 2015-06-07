gulp = require('gulp')
vinylPaths = require('vinyl-paths')
run = require('run-sequence')

paths = gulp.paths

$ = require('gulp-load-plugins')(
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license', 'del']
)

gulp.task 'partials', ->
  gulp.src([
    "#{paths.src}/{app,components}/**/*.html"
    "#{paths.tmp}/{app,components}/**/*.html"
  ])
  .pipe($.minifyHtml(
    empty: true
    spare: true
    quotes: true
  ))
  .pipe($.angularTemplatecache('templateCacheHtml.js',
    module: 'inspinia'
  ))
  .pipe(gulp.dest("#{paths.tmp}/partials/"))

gulp.task 'html', ['inject', 'partials'], ->
  partialsInjectFile = gulp.src("#{paths.tmp}/partials/templateCacheHtml.js", read: false)
  partialsInjectOptions =
    starttag: '<!-- inject:partials -->'
    ignorePath: "#{paths.tmp}/partials"
    addRootSlash: false

  htmlFilter = $.filter('*.html')
  jsFilter = $.filter('**/*.js')
  cssFilter = $.filter('**/*.css')
  assets = null

  gulp.src("#{paths.tmp}/serve/*.html")
    .pipe($.inject(partialsInjectFile, partialsInjectOptions))
    .pipe(assets = $.useref.assets())
    .pipe($.rev())
    .pipe(jsFilter)
    .pipe($.ngAnnotate())
    .pipe($.uglify(preserveComments: $.uglifySaveLicense))
    .pipe(jsFilter.restore())
    .pipe(cssFilter)
    .pipe($.replace('bower_components/font-awesome/fonts', 'fonts'))
    .pipe($.replace('bower_components/bootstrap/fonts', 'fonts'))
    .pipe($.csso())
    .pipe(cssFilter.restore())
    .pipe(assets.restore())
    .pipe($.useref())
    .pipe($.revReplace())
    .pipe(htmlFilter)
    .pipe($.minifyHtml(
      empty: true
      spare: true
      quotes: true
    ))
    .pipe(htmlFilter.restore())
    .pipe(gulp.dest("#{paths.dist}/"))
    .pipe($.size(title: "#{paths.dist}/", showFiles: true))

gulp.task 'images', ->
  gulp.src("#{paths.src}/assets/images/**/*")
    .pipe(gulp.dest("#{paths.dist}/assets/images/"))

gulp.task 'fonts', ->
  gulp.src($.mainBowerFiles())
    .pipe($.filter('**/*.{eot,svg,ttf,woff,woff2}'))
    .pipe($.flatten())
    .pipe(gulp.dest("#{paths.dist}/fonts/"))

gulp.task 'fontawesome', ->
  gulp.src('bower_components/font-awesome/fonts/*.{eot,svg,ttf,woff,woff2}')
    .pipe(gulp.dest("#{paths.dist}/fonts/"))

gulp.task 'misc', ->
  gulp.src("#{paths.src}/**/*.ico")
    .pipe(gulp.dest("#{paths.dist}/"))

gulp.task 'clean', ->
  gulp.src([
    "#{paths.dist}/"
    "#{paths.tmp}/"
    "#{paths.src}/app/**/*.js"
    '*.tar.gz'
  ])
  .pipe(vinylPaths($.del))

gulp.task 'build', (done) ->
  run 'coffee', ['html', 'images', 'fonts', 'fontawesome', 'misc'], done
