module AresMUSH
  module Rooms
    class GoCmd
      include CommandHandler

      attr_accessor :destination
      
      def parse_args
        self.destination = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.destination ]
      end
      
      def handle
        exit = enactor_room.get_exit(self.destination)
        Global.logger.info(exit.inspect)

        if (!exit || !exit.dest)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        
        if (!exit.allow_passage?(enactor))
          client.emit_failure t('rooms.cant_go_through_locked_exit')
          return
        end

        toll = exit.toll(enactor)

        enactor.expend(toll) do
          char = Character.find_one_by_name(exit.dest.room_owner)
          char.award(toll, t('lucidity.award_reasons.toll')) if exit.dest.room_owner != enactor.id && char
          Rooms.move_to(client, enactor, exit.dest, exit.name)
        end
      end
    end
  end
end
