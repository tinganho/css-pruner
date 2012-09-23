
lib_dir = File.dirname(__FILE__) + '/../lib/ruby'
$LOAD_PATH.unshift(lib_dir) unless $:.include?(lib_dir)

require 'headlesswebbrowser'
require 'test/unit'
require 'pp'

class TestHeadlessWebBrowser < Test::Unit::TestCase
 	

 	# Testing concat in building 
  def test_concat_in_build

  	# Some initial setup
  	config_file_path = File.dirname(__FILE__) + '/../tmp/test/config_file.rb'
  	config_file = File.new(config_file_path, 'w')
  	line1 = 'somecode1'
  	config_file.puts(line1)
  	config_file.close
  	options = { :config_file_path => '../tmp/test/cssp_config.rb'}
  	phantomJS = Cssp::PhantomJS.new(options)
  	phantomJS.config_file_path = config_file_path
  	phantomJS.build

  	# test
  	tmp_engine_file = File.readlines(Cssp::PhantomJS::TMP_ENGINE_FILE_PATH)
  	assert_equal(File.readlines(config_file_path).concat(File.readlines(Cssp::PhantomJS::CSSP_PRUNER_ENGINE_FILE_PATH)), tmp_engine_file)
  end

  

end