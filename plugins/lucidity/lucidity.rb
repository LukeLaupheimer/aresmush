$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Lucidity
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
    end

    def self.get_event_handler(event_name)      
      case event_name
      when "PoseEvent"
        return PoseEventHandler
      end
      nil
    end    
  end
end
