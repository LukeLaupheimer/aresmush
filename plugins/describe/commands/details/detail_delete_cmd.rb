module AresMUSH
  module Describe
    class DetailDeleteCmd
      include CommandHandler
           
      attr_accessor :target, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.target = trim_arg(args.arg1)
        self.name = titlecase_arg(args.arg2)
      end
      
      def required_lucidity(model)
        if model.is_a?(Room) && model.room_owner == enactor.id
          return Global.read_config('lucidity', 'costs', 'details_home')
        elsif mode.is_a?(Room)
          return Global.read_config('lucidity', 'costs', 'details_other') * model.barrier
        end
      end
      
      def required_args
        [ self.target, self.name ]
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.target, client, enactor) do |model|
          
          if (!model.details.has_key?(self.name))
            client.emit_failure t('describe.no_such_detail', :name => self.name)
            return
          end
          
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          enactor.expend(required_lucidity(model)) do
            details = model.details
            details.delete self.name
            model.update(details: details)
            client.emit_success t('describe.detail_deleted')
          end
        end
      end
    end
  end
end
