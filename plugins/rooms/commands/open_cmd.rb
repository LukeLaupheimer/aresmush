module AresMUSH
  module Rooms
    class OpenCmd
      include CommandHandler

      attr_accessor :name, :dest, :room, :matched_rooms

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = trim_arg(args.arg1)
        self.dest = trim_arg(args.arg2).to_s
        self.matched_rooms = Rooms.find_destination(self.dest, enactor)
        self.room = matched_rooms.first
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_build
        return if Rooms.can_build?(enactor) || enactor.room.room_owner == enactor.id
        t('dispatcher.not_allowed')
      end
      
      def check_same_area
        return if enactor.is_admin? || room.nil?
        t('lucidity.different_area') if room.area.id != enactor.room.area.id
      end

      def check_room_exists
        t('db.object_not_found') if room.nil?
      end

      def check_only_one_room_found
        t('db.object_ambiguous') if matched_rooms.count > 1
      end

      def handle
        enactor.expend(Global.read_config('lucidity', 'costs', 'create_intradreamscape_exit')) do
          client.emit_success Rooms.open_exit(self.name, enactor_room, room)
        end
      end
    end
  end
end
