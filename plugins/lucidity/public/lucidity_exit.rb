module AresMUSH
  class Exit
  	attribute :bridge, :type => DataType::Boolean, :default => false
  	attribute :bridge_cost, :type => DataType::Integer
  end
end