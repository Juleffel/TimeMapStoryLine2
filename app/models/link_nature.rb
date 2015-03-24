class LinkNature < ActiveRecord::Base
    has_many :links, inverse_of: :link_nature
    
    def json_attributes
        attributes.merge({"link_ids" => self.link_ids})
    end
  
    def self.hash_by(key)
        hash = {}
        self.all.each do |obj|
            hash[obj.send(key)] = obj.json_attributes
        end
        hash
    end
end
