require 'os'
require 'neography'
require "neo_active_graph"
# NeoActiveGraph indexes
#
namespace :graph do
  namespace :node do

    desc "Get node index list"
    task :list_indexes do
      indexes = NeoActiveGraph.db.list_node_indexes
      display indexes
    end

    desc "Create a node index [{name}]"
    task :create_index, [:name] do |task, args|
      resp = NeoActiveGraph.db.create_node_index args[:name], "exact", "lucene"
      display resp
    end

    desc "Drop a node index [{name}]"
    task :drop_index, [:name] do |task, args|
      begin
        resp = NeoActiveGraph.db.drop_node_index args[:name]
      rescue Neography::NotFoundException => err
        puts "Index '#{args[:name]}' could not be found."
      else
        puts "'#{args[:name]}' index removed"
      end

    end

  end

  namespace :relationship do

    desc "Get relationship index list"
    task :list_indexes do
      indexes = NeoActiveGraph.db.list_relationship_indexes
      display indexes
    end

    desc "Create a relationship index [{name}]"
    task :create_index, [:name] do |task, args|
      resp = NeoActiveGraph.db.create_relationship_index args[:name], "exact", "lucene"
      display resp
    end

    desc "Drop a relationship index [{name}]"
    task :drop_index, [:name] do |task, args|
      begin
        resp = NeoActiveGraph.db.drop_relationship_index args[:name]
      rescue Neography::NotFoundException => err
        puts "Index '#{args[:name]}' could not be found."
      else
        puts "'#{args[:name]}' index removed"
      end

    end

  end

  def display json
    if json.is_a?(Hash)
      json.each do |key, value|
        if value.is_a?(Hash)
          puts "#{key}:"
          value.each do |skey, svalue|
            puts "    #{skey}: #{svalue}"
          end
        else
          puts "#{key}: #{value}"
        end
      end
    else
      if json.blank?
        puts "No indexes."
      else
        puts json
      end
    end
  end
end

# neo4j testing instance
namespace :neo4j do

  neo4j_version = "2.0.2"

  desc "Fill DB with a lot of nodes"
  task :fill, [:count] do |task, args|
    count = args[:count] || 1000000

    (0..count).each do |obj|
      properties = {:email => "email#{obj}@mail.com", :name => "Someone no. #{obj}"}
      NeoActiveGraph.db.create_unique_node 'User_Idx', :email, properties[:email], properties
    end
  end

  desc "Install neo4j Community for testing"
  task :install, [:version] do |task, args|

    version = args[:version] || neo4j_version
    puts "Installing version #{version} ..."

    if OS.doze?
      puts "Not implemented yet :("
    else
      if File.exist?("neo4j-community-#{version}-unix.tar.gz")
        puts "Already downloaded..."
      else
        system "wget --progress=bar dist.neo4j.org/neo4j-community-#{version}-unix.tar.gz"
      end

      if File.directory?("neo4j-community-#{version}")
        puts "...and extracted."
      else
        puts "Extracting..."
        unless system "tar -xzf neo4j-community-#{version}-unix.tar.gz"
          puts "The file appears to be broken. use 'rake neo4j:remove' and ty again"
          exit 1
        end
        puts "Done!"
        puts "Changing server settings..."
        conf = File.read("neo4j-community-#{version}/conf/neo4j-server.properties")
        changed = conf.gsub!("org.neo4j.server.webserver.port=7474", "org.neo4j.server.webserver.port=7475")
        changed = changed.gsub!("org.neo4j.server.webserver.https.port=7473", "org.neo4j.server.webserver.https.port=7485")
        File.open("neo4j-community-#{version}/conf/neo4j-server.properties", "w") { |file| file.puts changed }
        puts "Done!"
        puts "Installing Splatial plugin..."
        system "wget dist.neo4j.org/spatial/neo4j-spatial-0.12-neo4j-2.0.1-server-plugin.zip"
        system "unzip -d neo4j-community-2.0.1/plugins/ neo4j-spatial-0.12-neo4j-2.0.1-server-plugin.zip"
      end

      puts "You're all good, the server will run @ http://localhost:7475/"
      puts "now run 'rake neo4j:start' to run the server."
    end
  end

  desc "Clean the database"
  task :clean do
    neo = Neography::Rest.new 'http://localhost:7475'
    result = neo.execute_query "START n=node(*) OPTIONAL MATCH n-[r]-() WHERE ID(n) <> 0 DELETE n,r"
    puts result
  end
  desc "Remove test neo4j"
  task :remove, [:version] do |task, args|

    version = args[:version] || neo4j_version
    if OS.doze?
      puts "Not implemented yet :("
    else
      puts "Removing #{version} and Spatial plugin..."
      system "rm -rf neo4j-community-#{version}* neo4j-spatial*"
    end
  end

  desc "Start neo4j testing instance"
  task :start, [:version] do |task, args|

    version = args[:version] || neo4j_version
    if OS.doze?
      puts "Not implemented yet :("
    else
      system "neo4j-community-#{version}/bin/neo4j start"
    end
  end

  desc "Stop neo4j testing instance"
  task :stop, [:version] do |task, args|

    version = args[:version] || neo4j_version
    if OS.doze?
      puts "Not implemented yet :("
    else
      system "neo4j-community-#{version}/bin/neo4j stop"
    end
  end
end
