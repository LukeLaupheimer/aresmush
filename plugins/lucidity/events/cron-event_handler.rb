module AresMUSH
  module Lucidity
    class CronEventHandler
      def on_event(event)
        Global.client_monitor.logged_in.each do |client, char|
          char.idle_bonus_timer = 60 if char.idle_bonus_timer.nil?

          char.idle_bonus_timer -= 1

          if char.idle_bonus_timer <= 0
            char.idle_bonus_timer = 60
            char.award(15)
          end

          char.save
        end
      end
    end
  end
end


