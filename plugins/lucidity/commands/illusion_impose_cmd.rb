module AresMUSH
  module Lucidity
    class IllusionImposeCmd
      include CommandHandler

      attr_accessor :illusion_description, :required_lucidity, :room, :owner

      def parse_args
        @illusion_description = cmd.args
        @room = enactor.room
        @owner = Character.find_one_by_name(room.room_owner)
        @required_lucidity = Global.read_config('lucidity', 'costs', 'describe_other_room') * (enactor.room.barrier + 1) * (owner.trespassing_resistance_from(enactor) + 1)
      end

      def check_you_are_ic
        t('lucidity.you_not_ic') if room.room_type != "IC"
      end

      def check_no_illusion_present
        t('lucidity.illusion_already_present') if room.illusion_present?
      end

      def handle
        enactor.expend(required_lucidity) do
          room.illusion_owner_id = enactor.id
          room.illusion_description = illusion_description
          room.illusion_words_remaining = Global.read_config('lucidity', 'words', 'illusion_start')
          room.save

          enactor.room.emit t('lucidity.illusion_imposed')
        end
      end
    end
  end
end
