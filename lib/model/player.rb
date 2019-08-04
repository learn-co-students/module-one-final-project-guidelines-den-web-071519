class Player < ActiveRecord::Base
    has_and_belongs_to_many :weapons
    has_and_belongs_to_many :spells
end