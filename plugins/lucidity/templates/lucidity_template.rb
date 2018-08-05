module AresMUSH
  module Lucidity
    class LucidityTemplate < AresMUSH::ErbTemplateRenderer
      attr_accessor :enactor

      def initialize(enactor)
        @enactor = enactor

        super File.dirname(__FILE__) + "/lucidity.erb"
      end

      def costs
        Global.read_config('lucidity', 'costs')
      end
      
      def idle_award
        Global.read_config('lucidity', 'awards', 'timer_award')
      end

      def my_lucidity
        enactor.lucidity
      end

      def multiplier_texts
        {
          :build_room_base => "number of rooms you have",
          :sympathetic_connection => "number of sympathetic connections you already have",
          :barrier_increase => "number of barriers room already has",
          :erect_bridge => "the total barriers of both rooms",
          :bridge_toll => "the barrier of the room being entered",
          :describe_other_room => "the barrier of the room being described"
        }
      end
    end
  end
end
