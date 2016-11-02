var gulp = require('gulp'),
    gutil = require('gulp-util'),
    webserver = require('gulp-webserver'),
    postcss = require('gulp-postcss'),
    autoprefixer = require('autoprefixer'),
    //precss = require('precss'),
    cssnano = require('cssnano'),

    gulpresponsive = require('gulp-responsive'),

    source = 'dev/',
    dest = 'dist/',
    img = 'img/';

/*
* TODO Parallax Effect
* TODO Less
* */
gulp.task('html', function() {
    gulp.src(source + '*.html')
        .pipe(gulp.dest(dest)); // copy html to dest directory
});

gulp.task('html-sync', function() {
    gulp.src(dest + '*.html')
        .pipe(gulp.dest(source)); // copy html to source directory
});

gulp.task('css', function() {
    gulp.src(source + 'style.css')
        .pipe(postcss([
            autoprefixer(),
            cssnano()
        ]))
        .on('error', gutil.log)
        .pipe(gulp.dest(dest + 'css'));
});

gulp.task('image', ['image-resize'], function () {
    gulp.src(source + img + '**/*.{png,jpg}')
        .pipe(gulp.dest(dest + img));
});

gulp.task('image-resize', function () { // resize images and move them to destination

    //withoutEnlargement: false,
    //    strictMatchImages: false,
    //    errorOnUnusedImage: false,
    //    skipOnEnlargement: true

    return gulp.src(source + img +'**/*.jpg')
        .pipe(gulpresponsive({
            '**/*jpg': [{
                // image-xs.webp is 544 pixels wide
                width: 544,
                rename: {
                    suffix: '-xs',
                    extname: '.jpg',
                },
            }, {
                // image-xs-2x.webp is 544 pixels wide
                width: 544 * 2,
                rename: {
                    suffix: '-xs-2x',
                    extname: '.jpg',
                },
            }, {
                // image-sm.webp is 768 pixels wide
                width: 768,
                rename: {
                    suffix: '-sm',
                    extname: '.jpg',
                },
            }, {
                // image-sm-2x.webp is 768 pixels wide
                width: 768 * 2,
                rename: {
                    suffix: '-sm-2x',
                    extname: '.jpg',
                },
            }, {
                // image-md.webp is 992 pixels wide
                width: 992,
                rename: {
                    suffix: '-md',
                    extname: '.jpg',
                },
            }, {
                // image-md-2x.jpg is 992 pixels wide
                width: 992 * 2,
                rename: {
                    suffix: '-md-2x',
                    extname: '.jpg',
                },
            }, {
                // image-lg.jpg is 1280 pixels wide
                width: 1280,
                rename: {
                    suffix: '-lg',
                    extname: '.webp',
                },
            }, {
                // image-lg-2x.jpg is 1280 pixels wide
                width: 1280 * 2,
                rename: {
                    suffix: '-lg-2x',
                    extname: '.jpg',
                },
            }, {
                // image-xl-2x.jpg is 2560 pixels wide
                width: 2560,
                rename: {
                    suffix: '-xl',
                    extname: '.jpg',
                },
            }, {
                // image-xl-2x.jpg is 2560 pixels wide
                width: 2560 * 2,
                rename: {
                    suffix: '-xl-2x',
                    extname: '.jpg',
                },
            }, {
                // image-xxl.jpg is 5120 pixels wide
                width: 5120,
                rename: {
                    suffix: '-xxl',
                    extname: '.jpg',
                },
            }, {
                // image-xxl.jpg is 5120 pixels wide
                width: 5120 * 2,
                rename: {
                    suffix: '-xxl-2x',
                    extname: '.jpg',
                },
            }, {
                // image-xs.webp is 544 pixels wide
                width: 544,
                rename: {
                    suffix: '-xs',
                    extname: '.webp',
                },
            }, {
                // image-xs-2x.webp is 544 pixels wide
                width: 544 * 2,
                rename: {
                    suffix: '-xs-2x',
                    extname: '.webp',
                },
            }, {
                // image-sm.webp is 768 pixels wide
                width: 768,
                rename: {
                    suffix: '-sm',
                    extname: '.webp',
                },
            }, {
                // image-sm-2x.webp is 768 pixels wide
                width: 768 * 2,
                rename: {
                    suffix: '-sm-2x',
                    extname: '.webp',
                },
            }, {
                // image-md.webp is 992 pixels wide
                width: 992,
                rename: {
                    suffix: '-md',
                    extname: '.webp',
                },
            }, {
                // image-md-2x.webp is 992 pixels wide
                width: 992 * 2,
                rename: {
                    suffix: '-md-2x',
                    extname: '.webp',
                },
            }, {
                // image-lg.webp is 1280 pixels wide
                width: 1280,
                rename: {
                    suffix: '-lg',
                    extname: '.webp',
                },
            }, {
                // image-lg-2x.webp is 1280 pixels wide
                width: 1280 * 2,
                rename: {
                    suffix: '-lg-2x',
                    extname: '.webp',
                },
            }, {
                // image-xl-2x.webp is 2560 pixels wide
                width: 2560,
                rename: {
                    suffix: '-xl',
                    extname: '.webp',
                },
            }, {
                // image-xl-2x.webp is 2560 pixels wide
                width: 2560 * 2,
                rename: {
                    suffix: '-xl-2x',
                    extname: '.webp',
                },
            }, {
                // image-xxl.webp is 5120 pixels wide
                width: 5120,
                rename: {
                    suffix: '-xxl',
                    extname: '.webp',
                },
            }, {
                // image-xxl.webp is 5120 pixels wide
                width: 5120 * 2,
                rename: {
                    suffix: '-xxl-2x',
                    extname: '.webp',
                },
            }],
        }, {
            withoutEnlargement: false,
            quality: 60,
            errorOnUnusedImage: false
        }))
        .pipe(gulp.dest(dest + img));
});

gulp.task('image-resize-team', function () { // resize images and move them to destination

    //withoutEnlargement: false,
    //    strictMatchImages: false,
    //    errorOnUnusedImage: false,
    //    skipOnEnlargement: true

    return gulp.src(source + img +'namcor/team/**/*.jpg')
        .pipe(gulpresponsive({
            '**/*jpg': [{
                // image-xs.webp is 544 pixels wide
                width: 544,
                rename: {
                    suffix: '-xs',
                    extname: '.jpg',
                },
            }, {
                // image-xs-2x.webp is 544 pixels wide
                width: 544 * 2,
                rename: {
                    suffix: '-xs-2x',
                    extname: '.jpg',
                },
            }, {
                // image-sm.webp is 768 pixels wide
                width: 768,
                rename: {
                    suffix: '-sm',
                    extname: '.jpg',
                },
            }, {
                // image-sm-2x.webp is 768 pixels wide
                width: 768 * 2,
                rename: {
                    suffix: '-sm-2x',
                    extname: '.jpg',
                },
            }, {
                // image-md.webp is 992 pixels wide
                width: 992,
                rename: {
                    suffix: '-md',
                    extname: '.jpg',
                },
            }, {
                // image-md-2x.jpg is 992 pixels wide
                width: 992 * 2,
                rename: {
                    suffix: '-md-2x',
                    extname: '.jpg',
                },
            }, {
                // image-lg.jpg is 1280 pixels wide
                width: 1280,
                rename: {
                    suffix: '-lg',
                    extname: '.webp',
                },
            }, {
                // image-lg-2x.jpg is 1280 pixels wide
                width: 1280 * 2,
                rename: {
                    suffix: '-lg-2x',
                    extname: '.jpg',
                },
            }, {
                // image-xl-2x.jpg is 2560 pixels wide
                width: 2560,
                rename: {
                    suffix: '-xl',
                    extname: '.jpg',
                },
            }, {
                // image-xl-2x.jpg is 2560 pixels wide
                width: 2560 * 2,
                rename: {
                    suffix: '-xl-2x',
                    extname: '.jpg',
                },
            }, {
                // image-xxl.jpg is 5120 pixels wide
                width: 5120,
                rename: {
                    suffix: '-xxl',
                    extname: '.jpg',
                },
            }, {
                // image-xxl.jpg is 5120 pixels wide
                width: 5120 * 2,
                rename: {
                    suffix: '-xxl-2x',
                    extname: '.jpg',
                },
            }, {
                // image-xs.webp is 544 pixels wide
                width: 544,
                rename: {
                    suffix: '-xs',
                    extname: '.webp',
                },
            }, {
                // image-xs-2x.webp is 544 pixels wide
                width: 544 * 2,
                rename: {
                    suffix: '-xs-2x',
                    extname: '.webp',
                },
            }, {
                // image-sm.webp is 768 pixels wide
                width: 768,
                rename: {
                    suffix: '-sm',
                    extname: '.webp',
                },
            }, {
                // image-sm-2x.webp is 768 pixels wide
                width: 768 * 2,
                rename: {
                    suffix: '-sm-2x',
                    extname: '.webp',
                },
            }, {
                // image-md.webp is 992 pixels wide
                width: 992,
                rename: {
                    suffix: '-md',
                    extname: '.webp',
                },
            }, {
                // image-md-2x.webp is 992 pixels wide
                width: 992 * 2,
                rename: {
                    suffix: '-md-2x',
                    extname: '.webp',
                },
            }, {
                // image-lg.webp is 1280 pixels wide
                width: 1280,
                rename: {
                    suffix: '-lg',
                    extname: '.webp',
                },
            }, {
                // image-lg-2x.webp is 1280 pixels wide
                width: 1280 * 2,
                rename: {
                    suffix: '-lg-2x',
                    extname: '.webp',
                },
            }, {
                // image-xl-2x.webp is 2560 pixels wide
                width: 2560,
                rename: {
                    suffix: '-xl',
                    extname: '.webp',
                },
            }, {
                // image-xl-2x.webp is 2560 pixels wide
                width: 2560 * 2,
                rename: {
                    suffix: '-xl-2x',
                    extname: '.webp',
                },
            }, {
                // image-xxl.webp is 5120 pixels wide
                width: 5120,
                rename: {
                    suffix: '-xxl',
                    extname: '.webp',
                },
            }, {
                // image-xxl.webp is 5120 pixels wide
                width: 5120 * 2,
                rename: {
                    suffix: '-xxl-2x',
                    extname: '.webp',
                },
            }],
        }, {
            withoutEnlargement: false,
            quality: 60,
            errorOnUnusedImage: false
        }))
        .pipe(gulp.dest(dest + img + 'namcor/team/'));
});

gulp.task('watch', function() {
    gulp.watch(source + '**/*.css', ['css']);
    gulp.watch(source + '*.html', ['html']);
    gulp.watch(dest + '*.html', ['html-sync']);
});

gulp.task('webserver', function() {
    gulp.src(dest)
        .pipe(webserver({
            livereload: true,
            open: true
        }));
});

gulp.task('default', ['image-resize', 'html', 'css', 'webserver','watch']);