module AresMUSH
  module Login
    class ConnectionEstablishedEventHandler
      CONNECT_FILES = Dir["game/text/**/connect*.txt"]

      def on_event(event)
        client = event.client
        
        # Connect screen ansi
        filename = CONNECT_FILES.sample
      
        if (File.exist?(filename))
          client.emit File.read(filename, :encoding => "UTF-8")
        else
          Global.logger.warn "Connect screen #{filename} missing!"
        end

        # Ares welcome text
        client.emit_ooc t('client.welcome', :version => AresMUSH.version ? AresMUSH.version.chomp : "")
      end
    end
  end
end
    
    
