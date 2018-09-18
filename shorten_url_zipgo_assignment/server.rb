require File.expand_path('../config/environment', __FILE__)
bundle
rake db:create
rake db:migrate
rails server