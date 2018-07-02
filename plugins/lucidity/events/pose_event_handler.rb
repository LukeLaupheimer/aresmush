module AresMUSH
  module Lucidity
    class PoseEventHandler 
      def on_event(event)
        return if event.is_ooc

        char = event.enactor
        room = char.room
        uwc = event.pose.scan(/\w+/).uniq.count

        online_chars = Global.client_monitor.logged_in.map { |client, char| char }
        
        player_count = room.characters.select { |char| online_chars.include?(char) }.count - 1

        award = uwc * player_count
       
        enactor_client = Global.client_monitor.find_client(char)

        char.lucidity += award
        char.save

        enactor_client.emit("%xnYour %x4Lucidity%xn has increased by %xy#{award}%xn. It is now #{char.lucidity}")
      end
    end
  end
end

