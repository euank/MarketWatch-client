# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marketwatch/client/version'

Gem::Specification.new do |spec|
  spec.name          = "marketwatch-client"
  spec.version       = Marketwatch::Client::VERSION
  spec.authors       = ["EuanK"]
  spec.email         = ["euank@euank.com"]
  spec.description   = %q{A simple gem to work with marketwatch}
  spec.summary       = %q{A simple gem to work with marketwatch}
  spec.homepage      = "https://github.com/euank/MarketWatch-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "httpclient"
end
