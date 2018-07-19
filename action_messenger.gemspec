
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "action_messenger/version"

Gem::Specification.new do |spec|
  spec.name          = "action_messenger"
  spec.version       = ActionMessenger::VERSION
  spec.authors       = ["h1kita"]

  spec.summary       = "Framework for delivering messages to Messenger (ex. slack)"
  spec.description   = "delivering messages to Messenger (ex. slack) using the familiar controller/view pattern."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'slack-ruby-client'
  spec.add_dependency 'actionpack'
  spec.add_dependency 'actionview'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'activejob'
end
