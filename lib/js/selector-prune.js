
var page = require('webpage').create(),
url = 'http://loc.unionen.se';

page.onConsoleMessage = function (msg) {
	if(msg != 'exit') {
		console.log(msg + ';');
	} else {
		phantom.exit();
	}
};
page.open(url, function(status) {
  
  page.evaluate(function() {

    var C = {};

		C.searchAStyleSheet = function(styleSheet) {

			if(styleSheet.cssRules == null) return;
			
			var rules = styleSheet.cssRules;

		  for(var i = 0; i < rules.length; i++) {
		  	if(rules[i].type == CSSRule.IMPORT_RULE) C.searchAStyleSheet(rules[i].styleSheet);
		  	if(rules[i].type != CSSRule.STYLE_RULE) continue;

		  	// Remove all proprietary pseudo element CSS selectors
        if(rules[i].selectorText.indexOf('::-') != -1) continue;

      	if((document.querySelectorAll(rules[i].selectorText)).length == 0) {
	  			console.log(rules[i].selectorText);
	  		}
		  }
		}

		var styleSheets = document.styleSheets;
		for(var i in styleSheets) {
		  if(styleSheets[i].cssRules == null) continue;
		  C.searchAStyleSheet(styleSheets[i]);
		}
		console.log('exit');

  });
});

