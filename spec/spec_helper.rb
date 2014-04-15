require 'neography'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
RSpec.configure do |config|

  config.after :all do
    neo = Neography::Rest.new (ENV["TRAVIS"] ? "http://localhost:7474" : "http://localhost:7475")
    # case ENV["NEO4J_VERSION"]
    # when "1.8.3"


    neo.execute_query "START n=node(*) OPTIONAL MATCH n-[r]-() WHERE ID(n) <> 0 DELETE n,r"
  end
end
