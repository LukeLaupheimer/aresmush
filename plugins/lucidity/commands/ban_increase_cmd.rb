module AresMUSH
  module Lucidity
    class BanIncreaseCmd
      include CommandHandler

      attr_accessor :char, :ban

      def parse_args
        @char = Character.find_one_by_name(cmd.args.to_s)
      end

      def check_target_exists
        t('db.object_not_found') if char.nil?
      end

      def handle
        find_or_establish_ban_object
        enactor.expend(required_lucidity) do
          ban.strength += 1
          ban.save

          client.emit_success t('lucidity.ban_increased', :trespasser => char.name, :level => ban.strength)
        end
      end

      private

      def find_or_establish_ban_object
        @ban = enactor.trespassing_from(char)
        
        @ban = Ban.create(
          :trespasser => char,
          :enforcer   => enactor,
          :strength   => 0
        ) if ban.nil?
      end

      def required_lucidity
        Global.read_config("lucidity", "costs", "ban_trespasser") * (@ban.strength + 1)
      end
    end
  end
end
