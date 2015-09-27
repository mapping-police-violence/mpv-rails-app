var carouselValues = [
'carousel_1.png',
'carousel_2.png',
'carousel_3.png',
'carousel_4.png'
]
var index = 0;


/**
 * Upon clicking the carousel left or right, swap out the image in the carousel.
 */
var onCarouselClick = function(evt) {
    var target = evt.target;
    var carouselImage = $(".carousel-image");

    if (target.id === 'left-carousel-link') {
        index = index -1;
    }

    else if (target.id === 'right-carousel-link') {
        index = index +1;
    }

    carouselImage.attr("src", carouselValues[index]);
}

document.addEventListener("click", onCarouselClick);