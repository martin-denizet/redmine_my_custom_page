require 'dispatcher'
module RedmineAlerts
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
          #          puts "My Function"
          #
          #          redirect_back_or_default_without_redirection(default)
          #
          #          back_url = CGI.unescape(params[:back_url].to_s)
          #          if !back_url.blank?
          #            begin
          #              uri = URI.parse(back_url)
          #              # do not redirect user to another host or to the login or register page
          #              if (uri.path.match(%r{/()}))
          #                puts "redirect"
          #                rend
          #                redirect_to({:controller => 'my', :action => 'page'})
          #                return
          #              end
          #            end
          #          end
        end
      end
    end
  end
end

Dispatcher.to_prepare do
  puts "pacth!!"
  unless ApplicationController.included_modules.include?(RedmineAlerts::Patches::ApplicationControllerPatch)
    ApplicationController.send(:include, RedmineAlerts::Patches::ApplicationControllerPatch)
  end
end
