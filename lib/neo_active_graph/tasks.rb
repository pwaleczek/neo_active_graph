# NeoActiveGraph indexes
#

namespace :graph do
  namespace :node do

    desc "Get node index list"
    task :list_indexes => :environment do
      indexes = NeoActiveGraph.db.list_node_indexes
      display indexes
    end

    desc "Create a node index [{name}]"
    task :create_index, [:name] => :environment do |task, args|
      resp = NeoActiveGraph.db.create_node_index args[:name], "exact", "lucene"
      display resp
    end

    desc "Drop a node index [{name}]"
    task :drop_index, [:name] => :environment do |task, args|
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
    task :list_indexes => :environment do
      indexes = NeoActiveGraph.db.list_relationship_indexes
      display indexes
    end

    desc "Create a relationship index [{name}]"
    task :create_index, [:name] => :environment do |task, args|
      resp = NeoActiveGraph.db.create_relationship_index args[:name], "exact", "lucene"
      display resp
    end

    desc "Drop a relationship index [{name}]"
    task :drop_index, [:name] => :environment do |task, args|
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
