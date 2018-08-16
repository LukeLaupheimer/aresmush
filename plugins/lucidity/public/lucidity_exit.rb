module AresMUSH
  class Exit
    attribute :bridge, :type => DataType::Boolean, :default => false
    attribute :bridge_cost, :type => DataType::Integer

    def toll(character)
      if bridge && dest.room_owner != character.id
        owner = Character.find_one_by_name(dest.room_owner)
        Global.read_config("lucidity", "costs", "bridge_toll") * (dest.barrier + 1) * (owner.trespassing_resistance_from(character) + 1)
      else
        0
      end
    end
  end
end
