module AresMUSH

  module Describe
    class DetailSetCmd
      include CommandHandler
            
      attr_accessor :name, :target, :desc
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.target = trim_arg(args.arg1)
        self.name = titlecase_arg(args.arg2)
        self.desc = args.arg3
      end
      
      def required_args
        [ self.target, self.desc, self.name ]
      end
      
      def required_lucidity(model)

        if model.is_a?(Room) && model.room_owner == enactor.id
          return Global.read_config('lucidity', 'costs', 'details_home')
        elsif mode.is_a?(Room)
          return Global.read_config('lucidity', 'costs', 'details_other') * model.barrier
        end
      end

      def handle
        VisibleTargetFinder.with_something_visible(self.target, client, enactor) do |model|
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          enactor.expend(required_lucidity(model)) do
            details = model.details
            details[self.name] = self.desc
            model.update(details: details)

            client.emit_success t('describe.detail_set')
          end
        end
      end
    end
  end
end
