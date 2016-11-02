/*
 *  on Document Ready
 * */
$(function () { // on deady

    /*
     * Wow controls animate.css
     * */
    var wow = new WOW(
        {
            boxClass: 'wow',      // animated element css class (default is wow)
            animateClass: 'animated', // animation css class (default is animated)
            offset: 0,          // distance to the element when triggering the animation (default is 0)
            mobile: true,       // trigger animations on mobile devices (default is true)
            live: true,       // act on asynchronously loaded content (default is true)
            callback: function (box) {
                // the callback is fired every time an animation is started
                // the argument that is passed in is the DOM node being animated
            },
            scrollContainer: null // optional scroll container selector, otherwise use window
        }
    );
    wow.init(); //init wow


    //var controller = new ScrollMagic.Controller(); // scrollMagic Controller


    $('#back-to-top').on('click', function (e) {
        e.preventDefault();
        //$('html,body').animate({
        //    scrollTop: 0
        //}, 700);

        $('html,body').animate({scrollTop: 0}, 800, 'easeOutExpo');
    });


    //$(window).bind('scroll', function () { // smooth scroll
    //    if ($(window).scrollTop() > $(window).height()/2) { // unhide when window
    //        $('#back-to-top').removeClass('wow fadeIn hidden-xs-up');
    //    } else {
    //        $('#back-to-top').addClass('wow fadeIn hidden-xs-up');
    //    }
    //});

    var scrollTrigger = 100 || $(window).height() / 2, // px
        backToTop = function () {
            var scrollTop = $(window).scrollTop();
            if (scrollTop > scrollTrigger) { // scrolled
                $('#back-to-top').addClass('');
                $('#back-to-top').removeClass('wow fadeIn animated hidden-xs-up');

            } else {
                $('#back-to-top').removeClass('');
                $('#back-to-top').addClass('wow fadeIn animated hidden-xs-up');

            }
        };
    backToTop();
    $(window).on('scroll', function () {
        backToTop();
    });


});