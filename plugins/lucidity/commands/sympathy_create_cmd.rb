module AresMUSH

  module Lucidity
    class SympathyCreateCmd
      include CommandHandler
      
      attr_accessor :target, :char, :source, :required_lucidity, :sympathy

      def parse_args
        @target = cmd.args
        @char = Character.find_one_by_name(target)
        @required_lucidity = Global.read_config("lucidity", "costs", "sympathetic_connection") * (char.sympathies.count + enactor.sympathies.count + 1) * (char.trespassing_resistance_from(enactor) + 1) if char.present? && enactor.present?
      end
      
      def check_target_is_used
        t('dispatcher.invalid_syntax', :cmd => 'sympathies') if target.nil?
      end

      def check_target_exists_and_is_online
        return if target.nil?
        t('db.no_char_online_found', :name => target) if char.nil? || char.client.nil?
      end

      def check_enough_resources
        return if char.nil?

        if char.sympathy_tokens > 0
          @source = :token
          nil
        elsif char.lucidity > 0
          @source = :lucidity
          nil
        else
          t("lucidity.not_enough", :required => required_lucidity, :current => char.lucidity)
        end
      end

      def check_no_sympathetic_connection
        return if char.nil?
        return t('lucidity.already_sympathetic', :name => char.name) if enactor.sympathizes_with?(char)
      end

      def required_args
      end
      
      def handle
        send("handle_#{source}")
        if sympathy.present?
          client.emit_success t('lucidity.sympathetic_established', :name => char.name)
          char.client.emit_success t('lucidity.sympathetic_imposed', :name => enactor.name)
        end
      end

      private

      def handle_token
        Global.logger.info("#{enactor.name} using a token to sympathize with #{char.name}. Tokens left before this: #{char.sympathy_tokens}")
        char.sympathy_tokens -= 1
        @sympathy = Sympathy.create(
          :sender => enactor,
          :receiver => char,
          :severance_cost => required_lucidity)
        char.save
      end

      def handle_lucidity
        enactor.expend(required_lucidity) do
          @sympathy = Sympathy.create(
            :sender => enactor,
            :receiver => char,
            :severance_cost => required_lucidity)
        end
      end
    end
  end
end
