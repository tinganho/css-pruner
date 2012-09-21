# Headless Webbrowser with PhantomJS

require 'optparse'
require 'pp'
require 'fileutils'
require File.dirname(__FILE__) + '/configparser'


module Cssp

	class PhantomJS

		attr_accessor :app_delegate_file
		attr_accessor :config_file

		def initialize(options)
			@options = options
		end

		# Runs headless web browser
		def run_server()
			raise "Undefined app delegate file" if @app_delegate_file.nil?
			config_parser = Cssp::ConfigParser.new()
			config_parser.config_file = @config_file
			config_parser.parse

			# TODO require the phantomJS binary
			
		end


	end
end