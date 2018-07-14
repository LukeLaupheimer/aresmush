module AresMUSH
  module Lucidity
    class RoleChangedEventHandler
      def on_event(event)
        char = Character[event.char_id]

        return if char.initiated
        return if char.roles.none? { |r| r.name_upcase == "APPROVED" }

        room = Room.create(
          :name        => t('lucidity.start_room.name'),
          :description => t('lucidity.start_room.description'),
          :room_owner  => char.id)

        char.room_home = room
        char.initiated = true

        char.save

        client = char.client

        return if client.nil?

        client.emit t('lucidity.start_room.approval_message')
        Rooms.move_to(client, char, room)
      end
    end
  end
end
