module AresMUSH
  class Room
  	attribute :barrier, :type => DataType::Integer, :default => 0

    def describe_cost(character)
      return Global.read_config("lucidity", "costs", "describe_own_room") if self.owned_by?(character)
      0
    end
  end
end
