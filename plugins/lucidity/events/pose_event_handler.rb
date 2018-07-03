module AresMUSH
  module Lucidity
    class PoseEventHandler 
      def on_event(event)
        return if event.is_ooc
        
        char = event.enactor
        room = char.room
        scene = room.scene

        return if scene.nil?

        uwc = event.pose.unique_word_count

        multiplier = scene.watchers.count + scene.participants.count + scene.likers.count

        bounty = uwc * multiplier * 10
        char.award(bounty)
       
      end
    end
  end
end

