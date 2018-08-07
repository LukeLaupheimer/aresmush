
module AresMUSH
  module Lucidity
    class LucidityGiftCmd
      include CommandHandler

      attr_accessor :target, :amount, :char

      def parse_args
        @target, @amount = cmd.args.scan(/(^\w+)=(\d+)$/).flatten
        @char = Character.find_one_by_name(target)
      end
      
      def check_target_exists_and_is_online
        t('db.no_char_online_found', :name => target) if char.nil? || char.client.nil?
      end

      def check_ammount_is_integer
        t('dispatcher.invalid_syntax', :cmd => "lucidity/gift") if amount.nil? || amount.scan(/^\d+$/i).count == 0
      end

      def handle
        amount = amount.to_i
        enactor.expend(amount) do
          char.award(amount)
        end
      end
    end
  end
end
