module AresMUSH
  class Character
    attribute :initiated, :type => DataType::Boolean, :default => false
    attribute :sympathy_tokens, :type => DataType::Integer, :default => Global.read_config("lucidity", "starting_tokens", "sympathy")
    attribute :bridge_tokens, :type => DataType::Integer, :default => Global.read_config("lucidity", "starting_tokens", "bridge")
    collection :senders, "AresMUSH::Sympathy", :sender
    collection :receivers, "AresMUSH::Sympathy", :receiver

    collection :trespassers, "AresMUSH::Ban", :enforcer
    collection :trespassings, "AresMUSH::Ban", :trespasser

    def trespassing_resistance_from(char)
      trespassing_from(char).try(:strength) || 0
    end

    def trespassing_for(char)
      tresspassings.select { |t| t.trespasser.id == self.id }.first
    end

    def trespassing_from(char)
      trespassers.select { |t| t.trespasser.id == char.id }.first
    end

    def describe_cost(character)
      Global.read_config("lucidity", "costs", "describe_self")
    end

    def sympathizes_with?(char)
      sympathies.include?(char.name_upcase)
    end

    def sympathies
      (senders.to_a + receivers.to_a).collect { |s| s.sender.name_upcase == self.name_upcase ? s.receiver.name_upcase : s.sender.name_upcase}.uniq
    end

    def sympathetic_connection_to(char)
      (senders.to_a + receivers.to_a).select { |s| s.sender == char || s.receiver == char }.first
    end

    def award(bounty, reason=nil)
      Global.logger.info("Awarding #{bounty} to #{name}.")
      return if bounty <= 0
      self.lucidity += bounty
      self.save

      if reason.nil?
        client.emit t('lucidity.award', :bounty => bounty, :current => self.lucidity) unless client.nil?
      else
        client.emit t('lucidity.award_with_reason', :bounty => bounty, :current => self.lucidity, :reason => reason) unless client.nil?
      end
    end

    def expend(payment)
      payment = payment.to_i
      payment = 0 if is_admin?
      Global.logger.info("#{name} is trying to spend #{payment} Lucidity...")
      if self.lucidity < payment
        client.emit t('lucidity.not_enough', :required => payment, :current => self.lucidity)
        return
      end

      begin
        yield
        self.lucidity -= payment
        self.save
        client.emit t('lucidity.you_spent', :payment => payment, :lucidity => self.lucidity) if payment > 0
      rescue => e
        client.emit t('lucidity.something_went_wrong')
        Global.logger.info("#{self.name} could not expend resources because #{e.message} \n\n#{e.backtrace.join("\n")}")
      end
    end
  end
end
