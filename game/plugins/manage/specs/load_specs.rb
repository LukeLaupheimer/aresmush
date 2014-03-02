require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(LoadCmd, "load foo")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
            
      describe :want_command do
        it "should want the load command" do
          handler.want_command?(client, cmd).should be_true
        end
        
        it "should not want another command" do
          cmd.stub(:root_is?).with("load") { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
      
      describe :crack! do
        it "should set the load target" do          
          handler.crack!
          handler.load_target.should eq 'foo'
        end
      end
      
      describe :validate_load_target do
        it "should reject command if no args specified" do
          handler.stub(:load_target) { nil }
          handler.validate_load_target.should eq 'manage.invalid_load_syntax'
        end
        
        it "should accept command otherwise" do
          handler.stub(:load_target) { "foo" }
          handler.validate_load_target.should eq nil
        end
      end
      
      describe :handle do
        context "load config" do
          before do
            @config_reader = double
            Global.stub(:config_reader) { @config_reader }
            init_handler(LoadCmd, "load")
            handler.load_target = "config"
          end

          it "should load config and notify client" do           
            @config_reader.should_receive(:read) {}
            client.should_receive(:emit_success).with('manage.config_loaded')
            handler.handle
          end
          
          it "should handle errors from config load" do
            @config_reader.should_receive(:read) { raise "Error" }
            client.should_receive(:emit_failure).with('manage.error_loading_config')
            handler.handle
          end          
        end
        
        context "load locale" do
          before do
            @locale = double
            Global.stub(:locale) { @locale }
            init_handler(LoadCmd, "load")
            handler.load_target = "locale"
          end
          
          it "should reload the locale" do
            @locale.should_receive(:load!)
            handler.handle
          end     
        end
        
        context "load plugin" do
          before do
            @plugin_manager = double
            @locale = double
            Global.stub(:plugin_manager) { @plugin_manager }
            Global.stub(:locale) { @locale }
            
            init_handler(LoadCmd, "load")
            handler.load_target = "foo"
            
            AresMUSH.stub(:remove_const) {}
            client.stub(:emit_success)
            @plugin_manager.stub(:load_plugin) {}
            @locale.stub(:load!) {}
          end
          
          it "should load the plugin" do
            @plugin_manager.should_receive(:load_plugin).with("foo")
            handler.handle
          end
          
          it "should unload the plugin" do
            AresMUSH.should_receive(:remove_const).with("Foo")
            handler.handle
          end
          
          it "should notify the client" do
            client.should_receive(:emit_success).with('manage.plugin_loaded')
            handler.handle
          end
          
          it "should reload the locale" do
            @locale.should_receive(:load!)
            handler.handle
          end
          
          it "should notify client if plugin not found" do
            @plugin_manager.stub(:load_plugin) { raise SystemNotFoundException }
            client.should_receive(:emit_failure).with('manage.plugin_not_found')
            handler.handle
          end
          
          it "should notify client if plugin load has an error" do
            @plugin_manager.stub(:load_plugin) { raise "Error" }
            client.should_receive(:emit_failure).with('manage.error_loading_plugin')
            handler.handle
          end
        end
      end
    end
  end
end