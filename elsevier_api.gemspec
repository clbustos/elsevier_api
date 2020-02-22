# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elsevier_api/version'

Gem::Specification.new do |spec|
  spec.name          = "elsevier_api"
  spec.version       = ElsevierApi::VERSION
  spec.authors       = ["Claudio Bustos"]
  spec.email         = ["clbustos@gmail.com"]

  spec.summary       = %q{Interact with Elsevier API services}
  spec.description   = %q{Uses ElsevierApi API to retrieve multiple data}
  spec.homepage      = "https://github.com/clbustos/elsevier_api"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "nokogiri", "~> 1.6"

end
