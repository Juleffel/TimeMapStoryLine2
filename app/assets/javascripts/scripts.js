$(document).ready(function() {
	/***************** Waypoints ******************/
/*
	$('.wp1').waypoint(function() {
		$('.wp1').addClass('animated fadeInLeft');
	}, {
		offset: '75%'
	});
	$('.wp2').waypoint(function() {
		$('.wp2').addClass('animated fadeInDown');
	}, {
		offset: '75%'
	});
	$('.wp3').waypoint(function() {
		$('.wp3').addClass('animated bounceInDown');
	}, {
		offset: '75%'
	});
	$('.wp4').waypoint(function() {
		$('.wp4').addClass('animated fadeInDown');
	}, {
		offset: '75%'
	});*/

	/***************** Flickity ******************/

	/*
	$('#featuresSlider').flickity({
		cellAlign: 'left',
		contain: true,
		prevNextButtons: false
	});

	$('#showcaseSlider').flickity({
		cellAlign: 'left',
		contain: true,
		prevNextButtons: false,
		imagesLoaded: true
	});*/

	/***************** Fancybox ******************/

	/*$(".youtube-media").on("click", function(e) {
		var jWindow = $(window).width();
		if (jWindow <= 768) {
			return;
		}
		$.fancybox({
			href: this.href,
			padding: 4,
			type: "iframe",
			'href': this.href.replace(new RegExp("watch\\?v=", "i"), 'v/'),
		});
		return false;
	});

	$("a.single_image").fancybox({
		padding: 4,
	});*/

	/***************** Inputs ******************/

	//$(".js-scrollbar").mCustomScrollbar(); TODO

	// With JQuery
	var change_slider_color = function (slide, $slider) {
		var bgr = 50;
		var bgg = 50;
		var bgb = 50+(slide.value)*2;
		$slider.css({background: 'rgb('+bgr+','+bgg+','+bgb+')'});
	};
	if ($('.link_force').length > 0) {
		$('.link_force').each(function(i, input) {
			var $input = $(input);
			var link_force_slider = $input.slider(
				).on('slide', function (slide) {
					change_slider_color(slide, $input.parents('#link_force_slider').find('.slider-selection'));
				});

			var val = parseInt($input.val());
			link_force_slider.slider('value', val, true);
			change_slider_color({value: val}, $input.parents('#link_force_slider').find('.slider-selection'));
		});
	}

	/*var $fullscreen = $(".fullscreen");
	if ($fullscreen.length > 0) {
	  var $navbar = $('.navbar');
	  var resize = function () {
	    var height = $(window).height() - $navbar.height();
	    $fullscreen.height(height);
    	$fullscreen.css({top: $navbar.height()});
	  };
	  resize();
	  $(window).resize(resize);
	}*/
	//$('.tiny-button').disableSelection();

	$('.datepicker').datepicker({
		format: "dd/mm/yyyy",
	    startDate: "01/01/1900",
	    defaultViewDate: {year: 1980},
	    startView: 2,
	    language: "fr",
	    autoclose: true
	});

	$("select.imageselect").imagepicker({hide_select: false});
});

/***************** Nav Transformicon ******************/

/* When user clicks the Icon */
/*$(".nav-toggle").click(function() {
	$(this).toggleClass("active");
	$(".overlay-boxify").toggleClass("open");
});*/

/* When user clicks a link */
/*$(".overlay ul li a").click(function() {
	$(".nav-toggle").toggleClass("active");
	$(".overlay-boxify").toggleClass("open");
});*/

/* When user clicks outside */
/*$(".overlay").click(function() {
	$(".nav-toggle").toggleClass("active");
	$(".overlay-boxify").toggleClass("open");
});*/

/***************** Smooth Scrolling ******************/

/*$('a[href*=#]:not([href=#])').click(function() {
	if (location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') && location.hostname === this.hostname) {

		var target = $(this.hash);
		target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
		if (target.length) {
			$('html,body').animate({
				scrollTop: target.offset().top
			}, 2000);
			return false;
		}
	}
});*/
