module AresMUSH
  module Lucidity
    class CronEventHandler
      def on_event(event)
        return if Time.now.min != 57

        Global.client_monitor.logged_in.each do |client, char|
          char.award(15)
        end
      end
    end
  end
end


