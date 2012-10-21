
lib_dir = File.dirname(__FILE__) + '/../lib/ruby'
$LOAD_PATH.unshift(lib_dir) unless $:.include?(lib_dir)
$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'headlesswebbrowser'
require 'test/unit'
require 'pp'
require 'test_helpers'


class TestHeadlessWebBrowser < Test::Unit::TestCase
 	
  CONFIG_FILE_PATH = File.dirname(__FILE__) + '/files/cssp_config.js'

  include TestHelpers

  def test_concat_in_build
  	create_tmp_engine_file(CONFIG_FILE_PATH)
    headless_web_browser = Cssp::PhantomJS.new()
    headless_web_browser.config_file_path = CONFIG_FILE_PATH
    headless_web_browser.build false
  	tmp_engine_file = File.readlines(headless_web_browser.tmp_engine_file.path)
  	assert_equal(File.readlines(CONFIG_FILE_PATH).concat(File.readlines(Cssp::PhantomJS::CSSP_PRUNER_ENGINE_FILE_PATH)), tmp_engine_file)
  end

  def test_validate_build_without_defined_urls
    headless_web_browser = Cssp::PhantomJS.new()
    headless_web_browser.config_file_path = File.dirname(__FILE__) + '/files/undefined_urls_config_test.js'
    assert_raise( RuntimeError ) { headless_web_browser.validate_build }
  end

  def test_validate_build_without_defined_output_file
    headless_web_browser = Cssp::PhantomJS.new()
    headless_web_browser.config_file_path = File.dirname(__FILE__) + '/files/undefined_output_file_config_test.js'
    assert_raise( RuntimeError ) { headless_web_browser.validate_build }
  end

  def test_get_output_file
    headless_web_browser = Cssp::PhantomJS.new()
    headless_web_browser.config_file_path = File.dirname(__FILE__) + '/files/get_output_file_test.js'
    assert_equal('somefilename', headless_web_browser.validate_build)
  end

  # def test_writing_result_to_output_file
  #   headless_web_browser = Cssp::PhantomJS.new()
  #   headless_web_browser.config_file_path = CONFIG_FILE_PATH
  #   headless_web_browser.build
  #   headless_web_browser.prune
  # end






end