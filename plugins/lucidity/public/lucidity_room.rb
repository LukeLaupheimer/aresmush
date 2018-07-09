module AresMUSH
  class Room
    def describe_cost(character)
      return 500 if self.owned_by?(character)
    end
  end
end
