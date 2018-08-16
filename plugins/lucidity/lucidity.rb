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
      when "CronEvent"
        return CronEventHandler
      when "RoleChangedEvent"
        return RoleChangedEventHandler
      end
      nil
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "sympathy"
        case cmd.switch
        when "establish"
          return SympathyCreateCmd
        when "sever"
          return SympathyDestroyCmd
        end
      when "barrier"
        case cmd.switch
        when "strengthen"
          return BarrierStrengthenCmd
        end
      when "bridge"
        case cmd.switch
        when "erect"
          return BridgeErectCmd
        end
      when "lucidity"
        case cmd.switch
        when "gift"
          return LucidityGiftCmd
        else
          return LucidityDisplayCmd
        end
      when "illusion"
        case cmd.switch
        when "impose"
          return IllusionImposeCmd
        when "evaporate"
          return IllusionEvaporateCmd
        when "title"
          return IllusionTitleCmd
        end
      when "ban"
        case cmd.switch
        when "increase"
          return BanIncreaseCmd
        when "forgive"
          return BanForgiveCmd
        end
      end
      nil
    end
  end
end
