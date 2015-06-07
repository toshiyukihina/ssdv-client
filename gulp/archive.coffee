gulp = require('gulp')
tar = require('gulp-tar')
gzip = require('gulp-gzip')
run = require('run-sequence')

paths = gulp.paths
packageJson = gulp.packageJson

gulp.task 'archive', ->
  gulp.src("#{paths.dist}/**/*")
    .pipe(tar("#{packageJson.name}.tar"))
    .pipe(gzip())
    .pipe(gulp.dest('.'))

gulp.task 'package', (done) ->
  run 'clean', 'build', 'archive', done
