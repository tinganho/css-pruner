Gem::Specification.new do |s|
  s.name        = 'csspruner'
  s.version     = '0.0.1'
  s.date        = '2010-04-28'
  s.summary     = 'Hola!'
  s.description = 'A simple hello world gem'
  s.authors     = ['Tingan Ho']
  s.email       = 'nick@quaran.to'
  s.files       = FileList[
                    'lib/**/*.rb',
                    'bin/*',
                    '[A-Z]*',
                    'test/**/*'
                  ].to_a
  s.executables << 'cssp'
  s.homepage    =
    'http://rubygems.org/gems/hola'
end