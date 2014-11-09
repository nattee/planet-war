class Map < ActiveRecord::Base
  attr_accessible :map_file

  def self.get_random
    a = rand(Map.count)
    return Map.first(offset: a)
  end
end
