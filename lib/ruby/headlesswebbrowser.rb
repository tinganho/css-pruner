# Headless Webbrowser with PhantomJS

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'optparse'
require 'pp'
require 'fileutils'
require 'utils'


module Cssp

	class PhantomJS

		CSSP_PRUNER_ENGINE_FILE_PATH = File.dirname(__FILE__) + '/../js/csspruner.js'
		TMP_ENGINE_FILE_PATH = File.dirname(__FILE__) + '/../../tmp/app/tmp_engine_file.js'

		attr_accessor :cssp_engine_file
		attr_accessor :config_file_path

		def initialize
		end

		# Runs headless web browser
		def run_server()
			raise 'Undefined temp. engine file' unless File.exist?(TMP_ENGINE_FILE_PATH)
		end

		# Builds the temp. engine file
		def build
			tmp_engine_file = File.new(TMP_ENGINE_FILE_PATH, 'w')
			config_file_lines = File.readlines(@config_file_path)
			config_file_lines.each {|lines| tmp_engine_file.puts(lines)}
			cssp_engine_file_lines = File.readlines(CSSP_PRUNER_ENGINE_FILE_PATH)
			cssp_engine_file_lines.each {|lines| tmp_engine_file.puts(lines)}
			
			# Close files
			tmp_engine_file.close
		end

	end
end