module AresMUSH
  class Sympathy < Ohm::Model
    include ObjectModel
    include FindByName

    reference :sender, "AresMUSH::Character"
    reference :receiver, "AresMUSH::Character"
  end
end
