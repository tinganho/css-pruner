# Headless Webbrowser with PhantomJS

require 'optparse'
require 'pp'
require 'fileutils'
require File.dirname(__FILE__) + '/utils'


module Cssp

	class PhantomJS

		attr_accessor :cssp_engine_file
		attr_accessor :config_file

		def initialize(options)
			@options = options
		end

		# Runs headless web browser
		def run_server()
			raise "Undefined app delegate file" if @cssp_engine_file.nil?

			# TODO require the phantomJS binary
			
		end

		# Builds the app delegate file and config file
		def build
			
		end

	end
end