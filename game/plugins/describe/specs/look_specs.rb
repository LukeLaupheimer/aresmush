require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe LookCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(LookCmd, "look something")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      
      describe :want_command? do
        it "wants the look command" do
          cmd.stub(:root_is?).with("look") { true }
          handler.want_command?(client, cmd).should be_true
        end
        
        it "doesn't want another command" do
          cmd.stub(:root_is?).with("look") { false }
          handler.want_command?(client, cmd).should be_false
        end
      end
      
      describe :crack do
        it "should set the target" do
          init_handler(LookCmd, "look Bob's Room")
          handler.crack!
          handler.target.should eq "Bob's Room"
        end
        
        it "should use here if there's no target" do
          init_handler(LookCmd, "look")
          handler.crack!
          handler.target.should eq "here"
        end
      end
      
      describe :handle do
        before do
          handler.crack!
        end
        
        context "target found" do
          before do
            @model = double
            VisibleTargetFinder.stub(:find) { FindResult.new(@model, nil)}
            client.stub(:emit)
            Describe.stub(:get_desc) { "a desc" }
          end

          it "should find a visible target in the looker's room" do
            VisibleTargetFinder.should_receive(:find).with("something", client) { FindResult.new(@model, nil)}
            handler.handle
          end
          
          it "should get the desc from the interface" do          
            Describe.should_receive(:get_desc).with(@model) { "a desc" }
            handler.handle
          end
        
          it "should emit the desc to the client" do
            client.should_receive(:emit).with("a desc")
            handler.handle
          end    
        end
        
        context "target not found" do
          before do
            VisibleTargetFinder.stub(:find) { FindResult.new(nil, "an error") }
          end
          
          it "should emit the error to the client" do
            client.should_receive(:emit_failure).with("an error")
            handler.handle
          end
          
          it "should not emit the desc" do
            client.should_not_receive(:emit)
            client.stub(:emit_failure)
            handler.handle
          end
        end
      end
    end
  end
end