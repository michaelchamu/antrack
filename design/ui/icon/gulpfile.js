var gulp = require('gulp'),
    gutil = require('gulp-util'),
    webserver = require('gulp-webserver'),
    path = require('path'),
    less = require('gulp-less'),
    favicons = require('gulp-favicons'),
    ga = require('gulp-ga'),
    htmlreplace = require('gulp-html-replace'),
//replacetask = require('gulp-replace-task'),
    replace = require('gulp-replace'),
    rename = require('gulp-rename'),
    uglify = require('gulp-uglify'),
    postcss = require('gulp-postcss'),
    inlinecss = require('gulp-inline-css'),
    base64 = require('gulp-base64'),
    inline = require('gulp-inline'),
    gulpif = require('gulp-if'),
    filter = require('gulp-filter'),
    //inlinecss = require('inline-css'),

//font64 = require('gulp-simplefont64'), // nice for auto @font-face ruleset

//autoprefixer = require('autoprefixer')({
//    browsers: [
//        //
//        // Official browser support policy:
//        // http://v4-alpha.getbootstrap.com/getting-started/browsers-devices/#supported-browsers
//        //
//        'Chrome >= 35', // Exact version number here is kinda arbitrary
//        // Rather than using Autoprefixer's native "Firefox ESR" version specifier string,
//        // we deliberately hardcode the number. This is to avoid unwittingly severely breaking the previous ESR in the event that:
//        // (a) we happen to ship a new Bootstrap release soon after the release of a new ESR,
//        //     such that folks haven't yet had a reasonable amount of time to upgrade; and
//        // (b) the new ESR has unprefixed CSS properties/values whose absence would severely break webpages
//        //     (e.g. `box-sizing`, as opposed to `background: linear-gradient(...)`).
//        //     Since they've been unprefixed, Autoprefixer will stop prefixing them,
//        //     thus causing them to not work in the previous ESR (where the prefixes were required).
//        'Firefox >= 31', // Current Firefox Extended Support Release (ESR)
//        // Note: Edge versions in Autoprefixer & Can I Use refer to the EdgeHTML rendering engine version,
//        // NOT the Edge app version shown in Edge's "About" screen.
//        // For example, at the time of writing, Edge 20 on an up-to-date system uses EdgeHTML 12.
//        // See also https://github.com/Fyrd/caniuse/issues/1928
//        'Edge >= 12',
//        'Explorer >= 9',
//        // Out of leniency, we prefix these 1 version further back than the official policy.
//        'iOS >= 8',
//        'Safari >= 8',
//        // The following remain NOT officially supported, but we're lenient and include their prefixes to avoid severely breaking in them.
//        'Android 2.3',
//        'Android >= 4',
//        'Opera >= 12'
//    ]
//}),
    autoprefixer = require('autoprefixer'),
    htmlAutoprefixer = require("gulp-html-autoprefixer"),
//precss = require('precss'),

    cssnano = require('cssnano'),
    gulpcdnizer = require('gulp-cdnizer'),

    gulpresponsive = require('gulp-responsive'),

    source = 'dev/',
    dest = 'dist/',
    img = 'images/',
    bsSource = source + 'bootstrap/dist/**/*';



gulp.task('html', function () {

    return gulp.src(source + '*.html')
        .pipe(gulp.dest(dest))
});

// create favicons and device icons
gulp.task("favicons", ['html'], function () {
    return gulp.src(source + "brand/" + "icon.png").pipe(favicons({
        appName: "antrack",
        appDescription: "antrack app",
        developerName: "Code Week",
        developerURL: "https://codeweek.slack.com",
        background: "transparent",
        path: "favicons/",
        url: "http://nust.na/antrack",
        display: "standalone",
        orientation: "portrait",
        version: 1.0,
        logging: false,
        online: false,
        html: dest + "favicon-markup.html",
        pipeHTML: false,
        replace: true
    }))
        .on("error", gutil.log)
        .pipe(gulp.dest(dest + 'favicons'));
});

// components
gulp.task('components', function () {
    return gulp.src(source + 'components/**/*')
        .pipe(gulp.dest(dest + 'components')); // bower components
});

// components
gulp.task('essentials', function () {
    gulp.src(source + 'fonts/**/*')
        .pipe(gulp.dest(dest + 'fonts')); // transfer fonts
    gulp.src(source + 'brand/**/*')
        .pipe(gulp.dest(dest + img + 'brand')); // transfer brand assets
    return gulp.src(source + '*.{txt,png,ico,xml}')
        .pipe(gulp.dest(dest)); // transfer icons, favicons, text, xml files
});

// js
gulp.task('js', function () {
    return gulp.src(source + 'js/**/*.js')
        .pipe(uglify())
        .pipe(gulp.dest(dest + 'js'));
});


/*
 * Less
 * */
gulp.task('less', function () {
    return gulp.src(source + 'less/style.less')
        .pipe(less({
            paths: [path.join(__dirname, 'less', 'includes')]
        }))
        .pipe(gulp.dest(source + 'css'));
});

// bootstrap
//gulp.task('bootstrap', function() {
//
//    // bootstrap
//    return gulp.src(bsSource + '**/*')
//        .on('error', gutil.log)
//        .pipe(gulp.dest(dest + 'css/bootstrap'));
//
//});

/*
 * css
 * */
gulp.task('css', ['less'], function () {
    return gulp.src(source + 'css/style.css')
        .pipe(postcss([
            autoprefixer({
                browsers: [
                    //
                    // Official browser support policy:
                    // http://v4-alpha.getbootstrap.com/getting-started/browsers-devices/#supported-browsers
                    //
                    'Chrome >= 35', // Exact version number here is kinda arbitrary
                    // Rather than using Autoprefixer's native "Firefox ESR" version specifier string,
                    // we deliberately hardcode the number. This is to avoid unwittingly severely breaking the previous ESR in the event that:
                    // (a) we happen to ship a new Bootstrap release soon after the release of a new ESR,
                    //     such that folks haven't yet had a reasonable amount of time to upgrade; and
                    // (b) the new ESR has unprefixed CSS properties/values whose absence would severely break webpages
                    //     (e.g. `box-sizing`, as opposed to `background: linear-gradient(...)`).
                    //     Since they've been unprefixed, Autoprefixer will stop prefixing them,
                    //     thus causing them to not work in the previous ESR (where the prefixes were required).
                    'Firefox >= 31', // Current Firefox Extended Support Release (ESR)
                    // Note: Edge versions in Autoprefixer & Can I Use refer to the EdgeHTML rendering engine version,
                    // NOT the Edge app version shown in Edge's "About" screen.
                    // For example, at the time of writing, Edge 20 on an up-to-date system uses EdgeHTML 12.
                    // See also https://github.com/Fyrd/caniuse/issues/1928
                    'Edge >= 12',
                    'Explorer >= 9',
                    // Out of leniency, we prefix these 1 version further back than the official policy.
                    'iOS >= 8',
                    'Safari >= 8',
                    // The following remain NOT officially supported, but we're lenient and include their prefixes to avoid severely breaking in them.
                    'Android 2.3',
                    'Android >= 4',
                    'Opera >= 12'
                ]
            }),
            cssnano()
        ]))
        .on('error', gutil.log)
        .pipe(gulp.dest(dest + 'css'));
});


gulp.task('watch', function () {
    gulp.watch(bsSource + '**/*', ['bootstrap']);

    gulp.watch(source + 'components/*', ['components']);
    gulp.watch(source + 'brand/**/*', ['essentials']); // essential brand assets
    gulp.watch(source + 'font/**/*', ['essentials']); // essential fonts
    gulp.watch(source + '*.{txt,png,ico,xml}', ['essentials']); // essential files


    gulp.watch(source + 'less/style.less', ['less']);
    gulp.watch(source + '**/*.css', ['css']);

    gulp.watch(source + 'js/**/*.js', ['js']);

    gulp.watch(source + '*.html', ['html']);

    gulp.watch(source + 'index.html');

});

gulp.task('webserver', function () {
    gulp.src(dest)
        .pipe(webserver({
            livereload: true,
            open: true
        }));
});


//gulp.task('default', ['image-resize', 'html', 'css', 'webserver','watch']); // image resize

gulp.task('default', ['html', 'favicons', 'less', 'css', 'js', 'essentials', 'components', 'webserver', 'watch']);
