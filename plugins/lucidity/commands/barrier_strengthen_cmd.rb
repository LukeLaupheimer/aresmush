module AresMUSH

  module Lucidity
    class BarrierStrengthenCmd
      include CommandHandler
      
      attr_accessor :room

      def parse_args
        @room = enactor.room
      end
      
      def check_enactor_owns_it
        Global.logger.info(enactor.inspect)
        Global.logger.info(room.room_owner.inspect)
        t('lucidity.does_not_belong_to_you') if room.room_owner != enactor.id
      end
      
      def handle
        enactor.expend(Global.read_config("lucidity", "costs", "barrier_increase") * (room.barrier + 1)) do
          room.barrier += 1
          room.save
          client.emit_success t('lucidity.barrier_strengthened', :level => room.barrier)
        end
      end
    end
  end
end
