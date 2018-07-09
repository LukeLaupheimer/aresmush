module AresMUSH
  class Character
    def describe_cost(character)
      0
    end

    def award(bounty)
      return if bounty <= 0
      self.lucidity += bounty
      self.save

      client.emit "%xnYour %x4Lucidity%xn has increased by %xy#{bounty}%xn. It is now #{self.lucidity}" unless client.nil?
    end

    def expend(payment)
      Global.logger.info("#{name} is trying to spend #{payment} Lucidity...")
      if self.lucidity < payment
        client.emit "%xnYou must have %xy#{payment} %x4Lucidity%xn but you only have %xn#{self.lucidity}"
        return
      end

      begin
        yield
        client.emit "%xnYou spent %xy#{payment} %x4Lucidity."
        self.lucidity -= payment
        self.save
      rescue => e
        client.emit "%xnSomething went wrong"
        Global.logger.info("#{self.name} could not expend resources because #{e.message} \n\n#{e.backtrace.join("\n")}")
      end
    end
  end
end
