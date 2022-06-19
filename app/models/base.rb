class Base < ApplicationRecord
    validates :base_number, presence: true, length: { maximum: 5 },uniqueness: true 
    validates :base_name, presence: true, length: { maximum: 5 }
    validates :base_type, presence: true, length: { maximum: 5 }
    
    def self.updatable_attributes
        ["base_number", "base_name", "base_type"]
    end
end
