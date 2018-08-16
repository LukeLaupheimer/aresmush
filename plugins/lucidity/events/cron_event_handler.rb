module AresMUSH
  module Lucidity
    class CronEventHandler
      def on_event(event)
        Global.client_monitor.logged_in.each do |client, char|
          char.idle_bonus_timer += 1
          timer_award = Global.read_config("lucidity", "awards", "timer_award")
          timer_limit = Global.read_config("lucidity", "awards", "bonus_timer")
          if (char.idle_bonus_timer % timer_limit) == 0
            char.award(timer_award * (char.idle_bonus_timer / timer_limit), t('lucidity.award_reasons.idle'))
          end

          char.save
        end
      end
    end
  end
end


