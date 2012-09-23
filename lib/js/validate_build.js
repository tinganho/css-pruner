try {
	urls.length
} catch(e) {
	console.log('You have not defined your URL:s yet. var urls = ["http://www.something.com", ...]');
	phantom.exit();
}

try {
	output_file.length
} catch(e) {
	console.log('You must define an output_file. Ex: var output_file = path/to/file.');
	phantom.exit();
}

console.log('success');
phantom.exit();