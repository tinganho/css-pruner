# Headless Webbrowser with PhantomJS

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'optparse'
require 'pp'
require 'fileutils'
require 'tempfile'


module Cssp

	class PhantomJS

		ROOT = File.dirname(__FILE__) + '/../../'

		CSSP_PRUNER_ENGINE_FILE_PATH = File.dirname(__FILE__) + '/../js/csspruner.js'
		VALIDATE_BUILD_FILE_PATH = File.dirname(__FILE__) + '/../js/validate_build.js'
		GET_OUTPUT_FILE_FILE_PATH = File.dirname(__FILE__) + '/../js/get_output_file.js'

		attr_accessor :cssp_engine_file
		attr_accessor :config_file_path
		attr_accessor :output_file_path
		attr_accessor :tmp_engine_file

		# Temporary files
		attr_accessor :tmp_engine_file_path

		# Runs headless web browser
		def prune

			result = `#{ROOT}vendor/phantomjs #{@tmp_engine_file.path}`

			result = result.gsub("\n", '')

			output_file = File.new(@output_file_path, 'w')
			output_file.puts(result)
			output_file.close

			return result
		end

		# Builds the temp. engine file
		# @param validate [Boolean] If build should validate
		def build(validate = true)
			@tmp_engine_file = Tempfile.new('engine')
			config_file_lines = File.readlines(@config_file_path)
			config_file_lines.each {|lines| tmp_engine_file.puts(lines)}
			cssp_engine_file_lines = File.readlines(CSSP_PRUNER_ENGINE_FILE_PATH)
			cssp_engine_file_lines.each { |lines| tmp_engine_file.puts(lines) }
			
			# Close files
			tmp_engine_file.close

			# Validate build and set the output_file_path
			@output_file_path = validate_build if validate


		end

		# Validates the build
		# @return {String} output_file, return the output file path.
		def validate_build
			tmp_validate_build_file = Tempfile.new('validate_build')
			config_file = File.readlines(@config_file_path)
			config_file.each { |lines| tmp_validate_build_file.puts(lines) }
			validate_build_file = File.readlines(VALIDATE_BUILD_FILE_PATH)
			validate_build_file.each { |lines| tmp_validate_build_file.puts(lines) }
			tmp_validate_build_file.close

			result = `#{ROOT}vendor/phantomjs #{tmp_validate_build_file.path}`
			raise result if result.gsub("\n", '') != 'success'

			# Get the output filename
			tmp_get_output_file_file = Tempfile.new('get_output_file')
			config_file = File.readlines(@config_file_path)
			config_file.each { |lines| tmp_get_output_file_file.puts(lines) }
			get_output_file_file = File.readlines(GET_OUTPUT_FILE_FILE_PATH)
			get_output_file_file.each { |lines| tmp_get_output_file_file.puts(lines) }
			tmp_get_output_file_file.close
			output_file = `#{ROOT}vendor/phantomjs #{tmp_get_output_file_file.path}`
			output_file = output_file.gsub("\n", '')
			return output_file
		end

	end
end