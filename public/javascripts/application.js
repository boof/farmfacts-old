// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function rand(range) {
	if (Math.random) return Math.round(Math.random() * (range-1));
	else {
		var now = new Date();
		return (now.getTime() / 1000) % range;
	}
}

function randomBackground(element) {
	var randomIndex = rand(9) + 1;
	var backgroundImage = "url(/images/backgrounds/bg_" + randomIndex + ".gif)";

	element.style.backgroundImage = backgroundImage;
}
