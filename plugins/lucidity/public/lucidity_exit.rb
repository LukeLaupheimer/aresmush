module AresMUSH
  class Exit
    attribute :bridge, :type => DataType::Boolean, :default => false
    attribute :bridge_cost, :type => DataType::Integer

    def toll
      if bridge
        Global.read_config("lucidity", "costs", "bridge_toll") * (dest.barrier + 1)
      else
        0
      end
    end
  end
end