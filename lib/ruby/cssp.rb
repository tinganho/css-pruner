require 'optparse'
require 'pp'
require 'fileutils'

class Cssp 

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
  end

  def set_opts(opts)
    
    # Directory to find config file
    opts.on('-p PATH', '--path PATH', String, 'Path to CSS folder') do |path|
      @options[:config_folder] = path
      pp @options
    end

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
  end
end

# pp "Options:", options
# pp "ARGV:", ARGV