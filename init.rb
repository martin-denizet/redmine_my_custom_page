require 'redmine'

require 'redmine_my_custom_page/patches/application_controller_patch'
require 'redmine_my_custom_page/patches/welcome_controller_patch'

Redmine::Plugin.register :redmine_my_custom_page do
  name 'Redmine My Custom Page plugin'
  author 'Martin Denizet'
  description 'Adds a block in My page to see incoming deadline.
Sponsored by IREC Beijing co. ltd.
Adapted from redmine_extended_mypage Tsubo (http://code.google.com/p/tsubo-redmine-plugins/).
GNU GPL v2 license'
  version '0.0.2-dev'
  url 'https://github.com/martin-denizet'
  author_url 'https://github.com/martin-denizet'


  settings :default=>{
    'assigned_to_me_max_num'=>20,
    'redirect_welcome_to_my_page'=> "1",
    'redirect_logon_to_my_page'=> "1"
  }, :partial => 'settings/my_custom_page_settings'

end
