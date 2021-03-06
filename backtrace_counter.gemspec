# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backtrace_counter/version'

Gem::Specification.new do |spec|
  spec.name          = "backtrace_counter"
  spec.version       = BacktraceCounter::VERSION
  spec.authors       = ["Issei Naruta"]
  spec.email         = ["mimitako@gmail.com"]
  spec.description   = %q{BacktraceCounter is a simple profiler by counting backtraces}
  spec.summary       = %q{A simple profiler by counting backtraces}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
