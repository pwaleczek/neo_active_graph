require 'neography'
RSpec.configure do |config|

  config.after :all do
    # neo = Neography::Rest.new "http://localhost:7475"
    # neo.execute_query "START n=node(*) OPTIONAL MATCH n-[r]-() WHERE ID(n) <> 0 DELETE n,r"
  end
end
