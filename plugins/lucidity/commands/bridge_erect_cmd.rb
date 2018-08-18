module AresMUSH

  module Lucidity
    class BridgeErectCmd
      include CommandHandler
      
      attr_accessor :target, :char, :source, :sympathetic_connection

      def parse_args
        @target = cmd.args
        @char = Character.find_one_by_name(target)
        @sympathetic_connection = enactor.sympathetic_connection_to(char)
      end
      
      def check_formatted_correctly
        t('dispatcher.invalid_syntax', :cmd => "barriers") if target.nil? || target.strip.length == ""
      end

      def check_target_exists_and_is_online
        t('db.no_char_online_found', :name => target) if char.nil? || char.client.nil?
      end

      def check_you_are_ic
        t('lucidity.you_not_ic') if enactor.room.room_type != "IC"
      end

      def check_they_are_ic
        t('lucidity.they_not_ic') if char.room.room_type != "IC"
      end

      def check_no_sympathetic_connection
        return if char.nil?
        return t('lucidity.not_sympathetic', :name => char.name) if sympathetic_connection.nil?
      end

      def check_no_bridge
        return if char.nil?
        t('lucidity.bridge_already_erected', :dest => char.room.name) if enactor.room.exits.any? { |e| e.dest_id == char.room.id }
      end

      def required_args
      end
      
      def handle
        required_lucidity = Global.read_config("lucidity", "costs", "erect_bridge") * (enactor.bridge_tokens > 0 ?  0 : char.room.barrier + enactor.room.barrier) * (char.trespassing_resistance_from(enactor) + 1)

        enactor.expend(required_lucidity) do
          exits = (enactor.room.exits.collect(&:name) + char.room.exits.collect(&:name)).uniq
          i = 1
          while exits.include?("b#{i}")
            i += 1
          end

          exit_name = "b#{i}"

          exit1 = Exit.create(
            :name         => exit_name,
            :name_upcase  => exit_name.upcase,
            :source_id    => enactor.room.id,
            :dest_id      => char.room.id,
            :bridge       => true,
            :bridge_cost  => required_lucidity
            )

          exit1.save

          exit2 = Exit.create(
            :name         => exit_name,
            :name_upcase  => exit_name.upcase,
            :source_id    => char.room.id,
            :dest_id      => enactor.room.id,
            :bridge       => true,
            :bridge_cost  => required_lucidity
            )

          exit2.save

          erection_msg = t('lucidity.bridge_erected', :dest => char.room.name)
          enactor.room.characters.collect(&:client).reject(&:nil?).each do |client|
            client.emit erection_msg
          end

          erection_msg = t('lucidity.bridge_erected', :dest => enactor.room.name) 
          char.room.characters.collect(&:client).reject(&:nil?).each do |client|
            client.emit erection_msg
          end

          enactor.bridge_tokens -= 1
          enactor.save
        end
      end
    end
  end
end
