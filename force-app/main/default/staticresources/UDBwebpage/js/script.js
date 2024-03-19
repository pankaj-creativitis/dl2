
(function($) {
    $(function() {
        var jcarousel = $('.jcarousel');

        jcarousel
            .on('jcarousel:reload jcarousel:create', function () {
                var carousel = $(this),
                    width = carousel.innerWidth();
				
				if (width >= 768) {
                    width = width / 5;
                }
                else if (width >= 600) {
                    width = width / 3;
                } else if (width >= 350) {
                    width = width / 3;
                }

                carousel.jcarousel('items').css('width', Math.ceil(width) + 'px');
            })
            .jcarousel({
                wrap: 'circular'
            });

        $('.jcarousel-control-prev')
            .jcarouselControl({
                target: '-=1'
            });

        $('.jcarousel-control-next')
            .jcarouselControl({
                target: '+=1'
            });

        $('.jcarousel-pagination')
            .on('jcarouselpagination:active', 'a', function() {
                $(this).addClass('active');
            })
            .on('jcarouselpagination:inactive', 'a', function() {
                $(this).removeClass('active');
            })
            .on('click', function(e) {
                e.preventDefault();
            })
            .jcarouselPagination({
                perPage: 1,
                item: function(page) {
                    return '<a href="#' + page + '">' + page + '</a>';
                }
            });
    });
	$("#amount-slider").rangeslider({
		polyfill: false,
		onSlideEnd: function(position, value){
			var x = value;
			x = x.toString();
			var lastThree = x.substring(x.length-3);
			var otherNumbers = x.substring(0,x.length-3);
			if(otherNumbers != '')
				lastThree = ',' + lastThree;
			var rsString = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree;
			$("#amount-slider-val").html(rsString)
			//console.log('Position', position, 'Value', rsString);
		}
	});
	$("#duration-slider").rangeslider({
		polyfill: false,
		onSlideEnd: function(position, value){
			$("#duration-slider-val").html(value)
			//console.log('Position', position, 'Value', rsString);
		}
	});
	$("#interest-slider").rangeslider({
		polyfill: false,
		onSlideEnd: function(position, value){
			$("#interest-slider-val").html(value)
			//console.log('Position', position, 'Value', rsString);
		}
	});
	
})(jQuery);



var rangeSlider = function(){
var slider = $('.range-slider'),
  range = $('.range-slider__range'),
  value = $('.range-slider__value');

slider.each(function(){

value.each(function(){
  var value = $(this).prev().attr('value');
  $(this).html(value);
});

range.on('input', function(){
  $(this).next(value).html(this.value);
});
});
};

rangeSlider();
/*$('#v-pills-tab a').on('click', function (e) {
e.preventDefault()
$(this).tab('show')
});
$('#myTab a[href="#profile"]').tab('show') // Select tab by name
$('#myTab li:first-child a').tab('show') // Select first tab
$('#myTab li:last-child a').tab('show') // Select last tab
$('#myTab li:nth-child(3) a').tab('show') // Select third tab*/