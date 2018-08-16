module AresMUSH
  class Ban < Ohm::Model
    include ObjectModel
    include FindByName

    reference :trespasser, "AresMUSH::Character"
    reference :enforcer, "AresMUSH::Character"

    index :trespasser
    index :enforcer

    attribute :strength, :type => DataType::Integer
  end
end
