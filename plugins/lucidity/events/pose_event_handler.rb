module AresMUSH
  module Lucidity
    class PoseEventHandler 
      def on_event(event)
        return if event.is_ooc

        char = event.enactor
        room = char.room
        uwc = event.pose.unique_word_count

        online_chars = Global.client_monitor.logged_in.map { |client, char| char }
        
        player_count = room.characters.select { |char| online_chars.include?(char) }.count - 1

        bounty = uwc * player_count

        char.award(amount)
       
      end
    end
  end
end

