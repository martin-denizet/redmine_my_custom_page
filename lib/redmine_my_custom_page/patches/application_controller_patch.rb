require 'dispatcher'
module RedmineMyCustomPage
  module Patches
    module ApplicationControllerPatch

      def self.included(base) # :nodoc:

        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :redirect_back_or_default, :redirection
        end

      end

      module InstanceMethods

        def redirect_back_or_default_with_redirection(default)
          if Setting.plugin_redmine_my_custom_page['redirect_logon_to_my_page'].to_i==1
            back_url = CGI.unescape(params[:back_url].to_s)
            if !back_url.blank?
              begin
                uri = URI.parse(back_url)
                # do not redirect user to another host or to the login or register page
                if (uri.relative? || (uri.host == request.host)) && !uri.path.match(%r{/(login|account/register|)})
                  redirect_to(back_url)
                  return
                end
              rescue URI::InvalidURIError
                # redirect to default
              end
            end
            redirect_to default
          else
            redirect_back_or_default_without_redirection(default)
          end
        end
      end
    end
  end
end

Dispatcher.to_prepare do
  unless ApplicationController.included_modules.include?(RedmineMyCustomPage::Patches::ApplicationControllerPatch)
    ApplicationController.send(:include, RedmineMyCustomPage::Patches::ApplicationControllerPatch)
  end
end
