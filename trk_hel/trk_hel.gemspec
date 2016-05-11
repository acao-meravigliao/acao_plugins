lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trk_hel/version'

Gem::Specification.new do |spec|
  spec.name          = 'trk_hel'
  spec.version       = TrkHel::VERSION
  spec.authors       = ['Daniele Orlandi']
  spec.email         = ['daniele@orlandi.com']
  spec.summary       = %q{Trk hel}
  spec.description   = %q{Trk hel}
  spec.homepage      = 'https://acao.it/'
  spec.license       = 'GPL2'

  spec.files         = `git ls-files -z 2>/dev/null`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'yggdra_plugins'
end
