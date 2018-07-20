module AresMUSH
  module Rooms
    class BuildCmd
      include CommandHandler

      attr_accessor :name
      attr_accessor :exit
      attr_accessor :return_exit
      
      def parse_args
        # build <name>
        # build <name>=<outgoing exit>
        # build <name>=<outgoing exit>,<return exit>
        args = cmd.parse_args(/(?<name>[^\=]+)\=?(?<exit>[^\,]*),?(?<return_exit>[^\,]*)/)
        self.name = trim_arg(args.name)
        self.exit = trim_arg(args.exit)
        self.return_exit = trim_arg(args.return_exit)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor) && enactor.room.room_owner != enactor.id
        return nil
      end
      
      def handle
        cost = Rooms.can_build?(enactor) ? 0 : enactor.room_home.area.rooms.count * Global.read_config("lucidity", "costs", "build_room_base")

        enactor.expend(cost) do
          room = AresMUSH::Room.create(
            :name       => name,
            :area       => enactor.room.area,
            :room_owner => enactor.id)

          client.emit_success(t('rooms.room_created', :name => name))
          
          if (!self.exit.empty?)
            Rooms.open_exit(self.exit, enactor_room, room)
          end
          if (!self.return_exit.empty?)
            Rooms.open_exit(self.return_exit, room, enactor_room)
          end
          
          Rooms.move_to(client, enactor, room)          
        end
      end
    end
  end
end
