module AresMUSH
  module Lucidity
    class RoleChangedEventHandler
      def on_event(event)
        char = Character[event.char_id]

        return if char.roles.none? { |r| r.name_upcase == "APPROVED" }

        area = Area.create(
          :name        => t('lucidity.start_room.area_name', :character => char.name),
          :description => t('lucidity.start_room.area_description', :character => char.name)
          )

        room = Room.create(
          :name        => t('lucidity.start_room.name'),
          :description => t('lucidity.start_room.description'),
          :room_owner  => char.id,
          :area        => area)

        char.room_home = room
        char.initiated = true

        char.award(Global.read_config("lucidity", "awards", "starting"), t('lucidity.award_reasons.starting'))

        char.save

        client = char.client

        Channels.join_channel("Collective Unconscious", client, char, "col")

        Global.logger.info("Grabbing client")
        return if client.nil?

        Global.logger.info("Got it and it's there")
        client.emit t('lucidity.start_room.approval_message')
        Rooms.move_to(client, char, room)
      end
    end
  end
end
