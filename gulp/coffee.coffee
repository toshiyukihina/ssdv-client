gulp = require('gulp')
coffee = require('gulp-coffee')
coffeelint = require('gulp-coffeelint')
stylish = require('coffeelint-stylish')
sourcemaps = require('gulp-sourcemaps')
plumber = require('gulp-plumber')
notify = require('gulp-notify')
gutil = require('gulp-util')

paths = gulp.paths

gulp.task 'coffee', ->
  gulp.src("#{paths.src}/**/*.coffee")
    .pipe(plumber(errorHandler: notify.onError('<%= error.message %>')))
    .pipe(coffeelint('.coffeelintrc'))
    .pipe(coffeelint.reporter(stylish))
    .pipe(sourcemaps.init())
    .pipe(coffee(bare: true)).on('error', gutil.log)
    .pipe(sourcemaps.write())
    .pipe(gulp.dest("#{paths.tmp}/serve"));
