module AresMUSH
  module Lucidity
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.idle_bonus_timer = 0
      end
    end
  end
end
