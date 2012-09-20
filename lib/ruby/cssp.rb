

require 'optparse'
require 'pp'
require 'fileutils'


module Cssp

  class Exec 

    
    APP_DELEGATE_FILE = File.dirname(__FILE__) + '/../js/csspruner.js'


    # @param args [Array<String>] The command-line arguments
    def initialize(args)
      @args = args
      @options = {}
      @version = '0.0.1'
    end

    # Parses the command-line arguments and runs the executable.
    # Calls `Kernel#exit` at the end, so it never returns.
    #
    # @see #parse
    def parse!
      begin
        parse
      rescue Exception => e
        raise e if @options[:trace] || e.is_a?(SystemExit)

        $stderr.print "#{e.class}: " unless e.class == RuntimeError
        $stderr.puts "#{e.message}"
        exit 1
      end 
      exit 0
    end

    # Parses the command-line arguments and runs the executable.
    # This does not handle exceptions or exit the program.
    #
    # @see #parse!
    def parse
      @opts = OptionParser.new(&method(:set_opts))
      @opts.parse(@args)
      @options
      raise 'App delegate file does not exist' if !app_delegate_file_exist
      run_headless_web_browser
    end

    # Checks if app delegate file exists
    def app_delegate_file_exist
      File.exist?(APP_DELEGATE_FILE)
    end

    # Set options
    # @param opts [Object]
    def set_opts(opts)
      
      # Directory to find config file
      @options[:config_file_dir] = '.'
      @options[:config_file_dir] = @args[0] unless @args[0].nil?

      # Directory to find config file
      @options[:trace] = false
      opts.on('--trace', 'Traceback error calls') do
        @options[:trace] = true
      end

      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on_tail( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts @version
        exit 
      end

    end # End parse

    # For debugging
    def outputpp
      pp @options 
    end

    # Run headless web browser
    def run_headless_web_browser
      require File.dirname(__FILE__) + '/headlesswebbrowser'
      headless_web_browser = Cssp::PhantomJS.new(@options)
      headless_web_browser.app_delegate_file = APP_DELEGATE_FILE
      headless_web_browser.config_file = @options[:config_file_dir] + '/cspp_config.rb'
      headless_web_browser.run_server
      outputpp
    end

  end # End of class Cssp

end # End of module