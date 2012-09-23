# Headless Webbrowser with PhantomJS

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'optparse'
require 'pp'
require 'fileutils'
require 'utils'


module Cssp

	class PhantomJS

		ROOT = File.dirname(__FILE__) + '/../../'

		CSSP_PRUNER_ENGINE_FILE_PATH = File.dirname(__FILE__) + '/../js/csspruner.js'
		VALIDATE_BUILD_FILE_PATH = File.dirname(__FILE__) + '/../js/validate_build.js'
		GET_OUTPUT_FILE_FILE_PATH = File.dirname(__FILE__) + '/../js/get_output_file.js'

		# Temporary files
		TMP_ENGINE_FILE_PATH = File.dirname(__FILE__) + '/../../tmp/app/engine.js'
		TMP_VALIDATE_BUILD_FILE_PATH = File.dirname(__FILE__) + '/../../tmp/app/validate_build.js'
		TMP_GET_OUTPUT_FILE_FILE_PATH= File.dirname(__FILE__) + '/../../tmp/app/get_output_file.js'

		attr_accessor :cssp_engine_file
		attr_accessor :config_file_path

		@output_file

		def initialize
		end

		# Runs headless web browser
		def run_server()

			# Exceptions
			raise 'Undefined temp. engine file' unless File.exist?(TMP_ENGINE_FILE_PATH)

			# Run
			command = '#{ROOT}vendor/phantomjs #{ROOT}tmp/app/engine.js'
			result = `#{command}`
			return result
		end

		# Builds the temp. engine file
		# @param validate [Boolean] If build should validate
		def build(validate = true)
			tmp_engine_file = File.new(TMP_ENGINE_FILE_PATH, 'w')
			config_file_lines = File.readlines(@config_file_path)
			config_file_lines.each {|lines| tmp_engine_file.puts(lines)}
			cssp_engine_file_lines = File.readlines(CSSP_PRUNER_ENGINE_FILE_PATH)
			cssp_engine_file_lines.each { |lines| tmp_engine_file.puts(lines) }
			
			# Close files
			tmp_engine_file.close

			validate_build if validate
		end

		# Validates the build
		def validate_build
			tmp_validate_build_file = File.new(TMP_VALIDATE_BUILD_FILE_PATH, 'w')
			config_file = File.readlines(@config_file_path)
			config_file.each { |lines| tmp_validate_build_file.puts(lines) }
			validate_build_file = File.readlines(VALIDATE_BUILD_FILE_PATH)
			validate_build_file.each { |lines| tmp_validate_build_file.puts(lines) }
			tmp_validate_build_file.close

			result = `#{ROOT}vendor/phantomjs #{ROOT}tmp/app/validate_build.js`
			raise result if result.gsub("\n", '') != 'success'

			# Get the output filename
			tmp_get_output_file_file = File.new(TMP_GET_OUTPUT_FILE_FILE_PATH, 'w')
			config_file = File.readlines(@config_file_path)
			config_file.each { |lines| tmp_get_output_file_file.puts(lines) }
			get_output_file_file = File.readlines(GET_OUTPUT_FILE_FILE_PATH)
			get_output_file_file.each { |lines| tmp_get_output_file_file.puts(lines) }
			tmp_get_output_file_file.close
			@output_file = `#{ROOT}vendor/phantomjs #{ROOT}tmp/app/get_output_file.js`
			@output_file = @output_file.gsub("\n", '')
			return @output_file
		end

	end
end