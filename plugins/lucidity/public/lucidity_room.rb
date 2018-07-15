module AresMUSH
  class Room
    def describe_cost(character)
      return Global.read_config("lucidity", "costs", "describe_own_room") if self.owned_by?(character)
      0
    end
  end
end
