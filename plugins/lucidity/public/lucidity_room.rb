module AresMUSH
  class Room
  	attribute :barrier, :type => DataType::Integer, :default => 0

    def describe_cost(character)
      if self.owned_by?(character)
        Global.read_config("lucidity", "costs", "describe_own_room")
      else
        Global.read_config("lucidity", "costs", "describe_other_room") * (barrier + 1)
      end
    end
  end
end
