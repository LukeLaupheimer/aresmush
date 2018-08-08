
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
        Global.logger.info("Amount: #{amount.to_i}")
        price = amount.to_i
        enactor.expend(price) do
          char.award(price,t('lucidity.award_reasons.gift', :name => enactor.name))
        end
      end
    end
  end
end
