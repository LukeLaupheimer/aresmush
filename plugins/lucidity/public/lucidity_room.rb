module AresMUSH
  class Room
  	attribute :barrier, :type => DataType::Integer, :default => 0

    attribute :illusion_owner_id
    attribute :illusion_description
    attribute :illusion_words_remaining, :type => DataType::Integer, :default => 0
    attribute :illusion_evaporation_message

    def describe_cost(character)
      if self.owned_by?(character)
        Global.read_config("lucidity", "costs", "describe_own_room")
      else
        Global.read_config("lucidity", "costs", "describe_other_room") * (barrier + 1)
      end
    end

    def illusion_present?
      illusion_words_remaining > 0
    end
  end
end
