module AresMUSH
  module Lucidity
    class CronEventHandler
      def on_event(event)
        Global.client_monitor.logged_in.each do |client, char|
          char.idle_bonus_timer = Global.read_config("lucidity", "awards", "bonus_timer") if char.idle_bonus_timer.nil?

          char.idle_bonus_timer -= 1

          if char.idle_bonus_timer <= 0
            char.idle_bonus_timer = Global.read_config("lucidity", "awards", "bonus_timer")
            char.award(Global.read_config("lucidity", "awards", "timer_award"), t('lucidity.award_reasons.idle'))
          end

          char.save
        end
      end
    end
  end
end


