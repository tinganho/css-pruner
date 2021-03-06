
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'optparse'
require 'pp'
require 'fileutils'


module Cssp
  
  # Version number
  VERSION = '0.0.1'

  class Exec 

     # @param args [Array<String>] The command-line arguments
    def initialize(args)
      @args = args
      @options = {}
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
      run_headless_web_browser
    end

    # Set options
    # @param opts [Object]
    def set_opts(opts)
      
      # Directory to find config file
      @options[:config_file_dir] = '.'
      @options[:config_file_dir] = @args[0] unless @args[0].nil?
      @options[:config_file] = @options[:config_file_dir] + '/cssp_config.js'

      # Directory to find config file
      @options[:trace] = false
      opts.on('-t', '--trace', 'Traceback error calls') do
        @options[:trace] = true
      end

      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on_tail( '-h', '--help', 'Display this screen') do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail('-v', '--version', 'Show version') do
        puts VERSION
        exit 
      end

    end # End parse

    # Run headless web browser
    def run_headless_web_browser
      require File.dirname(__FILE__) + '/headlesswebbrowser'
      headless_web_browser = Cssp::PhantomJS.new()
      headless_web_browser.config_file_path = @options[:config_file_dir] + '/cssp_config.js'
      headless_web_browser.build
      headless_web_browser.prune
    end

  end # End of class Cssp

end # End of module