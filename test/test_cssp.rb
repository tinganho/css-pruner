lib_dir = File.dirname(__FILE__) + '/../lib/ruby'
$LOAD_PATH.unshift(lib_dir) unless $:.include?(lib_dir)
$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))


require 'cssp'
require 'test/unit'
require 'pp'

class TestCSSP < Test::Unit::TestCase

	# Test get the version
	def test_get_version
		result = `ruby bin/cssp -v`
		assert_equal(Cssp::VERSION, result.gsub("\n",''))
	end

	

end
