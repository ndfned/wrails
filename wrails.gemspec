Gem::Specification.new do |spec|
  spec.name        = 'wrails'
  spec.version     = '0.1.1'
  spec.summary     = 'Worse than Rails'
  spec.files       = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.author = 'ndfnd'
  spec.license = 'MIT'
  spec.homepage = 'https://github.com/ndfnd/wrails'
  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency 'rack', '>= 3.0.0', '< 4'
end
