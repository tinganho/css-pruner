lib_dir = File.dirname(__FILE__) + '/../lib/ruby'
$LOAD_PATH.unshift(lib_dir) unless $:.include?(lib_dir)

require 'cssp'
require 'test/unit'
require 'pp'

class TestHeadlessWebBrowser < Test::Unit::TestCase

	# Test get the version
	def test_get_version
		result = `ruby bin/cssp -v`
		assert_equal(Cssp::VERSION, result.gsub("\n",''))
	end

	

end
