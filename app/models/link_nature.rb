class LinkNature < ActiveRecord::Base
    extend HashBy
    
    has_many :links, inverse_of: :link_nature
    
    def json_attributes
        attributes.merge({"link_ids" => self.link_ids})
    end
end
