require 'dispatcher'
module RedmineMyCustomPage
  module Patches
    module WelcomeControllerPatch

      def self.included(base) # :nodoc:

        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :index, :redirection
        end

      end

      module InstanceMethods

        def index_with_redirection
          if Setting.plugin_redmine_my_custom_page['redirect_welcome_to_my_page'].to_i==1
            redirect_to({:controller => "my", :action => "page"})
          else
            index_without_redirection
          end
        end
      end
    end
  end
end

Dispatcher.to_prepare do
  unless WelcomeController.included_modules.include?(RedmineMyCustomPage::Patches::WelcomeControllerPatch)
    WelcomeController.send(:include, RedmineMyCustomPage::Patches::WelcomeControllerPatch)
  end
end
