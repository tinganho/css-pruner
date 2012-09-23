
module TestHelpers
	def create_tmp_engine_file(config_file_path)
		
  	config_file = File.new(config_file_path, 'w')
  	line1 = 'var urls = ["http://www.zacco.com", "http://www.zacco.com/news"]'
  	config_file.puts(line1)
  	config_file.close
  	phantomJS = Cssp::PhantomJS.new()
  	phantomJS.config_file_path = config_file_path
  	phantomJS.build(false)
	end
end