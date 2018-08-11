 module AresMUSH
  module Lucidity
    class IllusionTitleCmd
      include CommandHandler

      attr_accessor :title, :room

      def parse_args
        @title = cmd.args
        @room = enactor.room
      end

      def check_you_are_ic
        t('lucidity.you_not_ic') if room.room_type != "IC"
      end

      def check_own_illusion
        t('lucidity.illusion_not_yours') unless room.illusion_present? && room.illusion_owner_id == enactor.id
      end

      def handle
        room.illusion_title = title
        room.save
        enactor.client.emit_success t('lucidity.illusion_title_set')
      end
    end
  end
end
