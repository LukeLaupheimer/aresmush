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

        bounty = uwc * multiplier * Global.read_config("lucidity", "awards", "pose_multiplier")
        char.award(bounty, t('lucidity.award_reasons.pose'))
        
        if room.illusion_present?
          room.illusion_words_remaining -= uwc

          if room.illusion_words_remaining <= 0
            Scenes.add_to_scene(room.scene, room.illusion_evaporation_message)
            room.emit room.illusion_evaporation_message

            room.illusion_words_remaining = 0
            room.illusion_owner_id = nil
            room.illusion_title = nil
            room.illusion_evaporation_message = nil
            room.illusion_description = nil
          end

          room.save
        end
      end
    end
  end
end

