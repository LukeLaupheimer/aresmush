module AresMUSH
  class Character
    def award(bounty)
      return if bounty <= 0
      self.lucidity += bounty
      self.save

      client.emit "%xnYour %x4Lucidity%xn has increased by %xy#{bounty}%xn. It is now #{self.lucidity}" unless client.nil?
    end

  end
end
