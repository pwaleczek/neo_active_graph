Gem::Specification.new do |spec|
  spec.platform       = Gem::Platform::RUBY
  spec.name           = "neo_active_graph"
  spec.version        = "0.0.3"
  spec.summary        = "Neography ActiveRecord-like wrapper"
  spec.description    = ""

  spec.license        = "WTFPL"

  spec.author         = "Paweł Waleczek"
  spec.email          = "pawel@thisismyasterisk.org"
  spec.homepage       = "https://github.com/pwaleczek/neo_active_graph"

  spec.files          =  Dir["Readme.md", "License", "Rakefile", "spec/**/*", "lib/**/*"]
  spec.require_path   = "lib"

  spec.add_dependency "neography", "~> 1.3.12"
  spec.add_dependency "neo4j-cypher", "~> 1.0.3"

  spec.add_development_dependency "rspec"
end
