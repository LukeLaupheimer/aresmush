module AresMUSH
  module Lucidity
    class SympathyDestroyCmd
      include CommandHandler

      attr_accessor :target, :char, :sympathetic_connection

      def parse_args
        @target = cmd.args
        @char = Character.find_one_by_name(target)
        @sympathetic_connection = enactor.sympathetic_connection_to(char)
      end

      def check_no_sympathetic_connection
        return if char.nil?
        return t('lucidity.not_sympathetic', :name => char.name) if sympathetic_connection.nil?
      end

      def handle
        enactor.expend(sympathetic_connection.severance_cost.to_i) do
          sympathetic_connection.delete
          client.emit_success t('lucidity.you_severed_sympathy', :name => char.name)
          @char.client.emit_failure t('lucidity.your_sympathy_severed', :name => enactor.name) if char.client.present?
        end
      end
    end
  end
end