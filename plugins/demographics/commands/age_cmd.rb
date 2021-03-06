module AresMUSH
  module Demographics

    class AgeCmd
      include CommandHandler
      
      attr_accessor :age
      
      def required_args
        [ self.age ]
      end
         
      def check_chargen_locked
        Chargen.check_chargen_locked(enactor)
      end
      
      def parse_args
        self.age = trim_arg(cmd.args)
      end
      
      def handle
        bday = Date.new ICTime.ictime.year - self.age.to_i, ICTime.ictime.month, ICTime.ictime.day
        bday = bday - rand(364)
        
        enactor.update_demographic(:birthdate, bday)

        client.emit_success t('demographics.birthdate_set', 
          :birthdate => ICTime.ic_datestr(bday), 
          :age => enactor.age)
      end
        
    end
    
  end
end