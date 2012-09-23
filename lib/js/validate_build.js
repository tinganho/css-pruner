try {
	urls.length
} catch(e) {
	console.log('You have not defined your URL:s yet. var urls = ["http://www.something.com", ...]');
	phantom.exit();
}

try {
	output_filename.length
} catch(e) {
	console.log('You must define an output_filename. Ex: var output_filename = path/to/file.');
	phantom.exit();
}

console.log('success');
phantom.exit();