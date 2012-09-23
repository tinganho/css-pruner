
var ghostSelectors = [];

// Exit counter for different pages
var exitCounter = 0;
// Utils namespace
var UTILS = {};

/**
 * Make an intersection of two arrays
 * @param a [Array] An sorted array of elements
 * @param b [Array] An sorted array of elements
 * @result [Array] Returns the intersection of a & b
 */
 UTILS.intersectSafe = function(a, b) {
 	var ai=0, bi=0;
 	var result = new Array();

 	while( ai < a.length && bi < b.length )
 	{
 		if      (a[ai] < b[bi] ) ai++;
 		else if (a[ai] > b[bi] ) bi++;
 		else {
 			result.push(a[ai]);
 			ai++;
 			bi++;
 		}
 	}
 	return result;
 }

// Loop through all URL:s
for(var i in urls) {
	
	// Set url
	var url = urls[i],
	
	// Store the current page's ghost selectors
	currentPagesChostSelector = [],

	preprocessFunctionDef = ''
	
	try {
		window['preprocess_' + i]();
		preprocessFunctionDef =  window['preprocess_' + i].toString();
	} catch(e) {};
	

	// Instantiate PhantomJS object
	var page = require('webpage').create();

	/**
	 * Onconsole message are fired when console.log is
	 * @param selector [String] CSS selector string
	 */
	 page.onConsoleMessage = function (selector) {

	 	if(selector != 'exit') {
	 		currentPagesChostSelector.push(selector)
	 		if(ghostSelectors.indexOf(selector) == -1) {
	 			ghostSelectors.push(selector);
	 		}
	 	} else {
	 		exitCounter++;
	 		console.log(ghostSelectors);
	 		ghostSelectors.sort();
	 		currentPagesChostSelector.sort();
	 		UTILS.intersectSafe(ghostSelectors, currentPagesChostSelector);
	 		if(exitCounter == urls.length) {
	 			for(var i in ghostSelectors) {
	 				console.log(ghostSelectors.join(';\n'));
	 			}
	 			phantom.exit();
	 		}
	 	}
	 };

	 page.open(url, function(status) {

	 	page.evaluate(function(options) {

	 		var i = options[0],
	 		preprocessFunctionDef = options[1]

	 		var EVAL_FUNC = {};

	 		EVAL_FUNC.searchAStyleSheet = function(styleSheet) {

	 			if(styleSheet.cssRules == null) return;

	 			var rules = styleSheet.cssRules;
			  for(var i = 0; i < rules.length; i++) {
			  	if(rules[i].type == CSSRule.IMPORT_RULE) EVAL_FUNC.searchAStyleSheet(rules[i].styleSheet);
			  	if(rules[i].type != CSSRule.STYLE_RULE) continue;

			  	// Remove all proprietary pseudo element CSS selectors
			  	if(rules[i].selectorText.indexOf('::-') != -1) continue;

			  	if((document.querySelectorAll(rules[i].selectorText)).length == 0) {
			  		console.log(rules[i].selectorText);
			  	}
			  }
			}

			EVAL_FUNC.retrieveAllGhostSelectors = function() {
				var styleSheets = document.styleSheets;
				for(var i in styleSheets) {
					if(styleSheets[i].cssRules == null) continue;
					EVAL_FUNC.searchAStyleSheet(styleSheets[i]);
				}
				console.log('exit');
			}

			EVAL_FUNC.onDOMContentLoad = function() {

				eval(preprocessFunctionDef);
				var preprocessFunction = 'preprocess_' + i;
				try {
					window[preprocessFunction]();
				} catch(e) {};

				EVAL_FUNC.retrieveAllGhostSelectors();
			}
			EVAL_FUNC.onDOMContentLoad();

		}, [i + '', preprocessFunctionDef]);
	});
}




