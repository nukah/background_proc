lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'background_proc/version'

Gem::Specification.new do |spec|
  spec.name          = "background_proc"
  spec.version       = BackgroundProc::VERSION
  spec.authors       = ["Boris Gushin"]
  spec.email         = ['me@nile.ninja']

  spec.summary       = %q(Simple background processing engine)
  spec.description   = %q(Sidekiq lookalike but simplier)
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'sequel'
  spec.add_dependency 'oj'

  spec.add_development_dependency 'bundler', "~> 1.16"
  spec.add_development_dependency 'rake', "~> 10.0"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
end
