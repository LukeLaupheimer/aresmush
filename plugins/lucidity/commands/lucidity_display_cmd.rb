module AresMUSH
  module Lucidity
    class LucidityDisplayCmd
      include CommandHandler

      def parse_args
      end

      def handle
        template = LucidityTemplate.new(enactor)
        content = template.render
        client.emit content
      end
    end
  end
end

