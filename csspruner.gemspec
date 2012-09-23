Gem::Specification.new do |s|
  s.name        = 'csspruner'
  s.version     = '0.0.1'
  s.date        = '2010-04-28'
  s.summary     = 'Hola!'
  s.description = 'A simple hello world gem'
  s.authors     = ['Tingan Ho']
  s.email       = 'tingan@clockies.com'
  s.files       = Dir.glob("lib/**/*")
  s.files       += Dir.glob('test/**/*')
  s.files       += Dir.glob('bin/*')
  s.executables << 'cssp'
  s.homepage    =
    'http://rubygems.org/gems/hola'
end