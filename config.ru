require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

#here is where to mount other controllers with the keyword 'use'

#code to send PATCH and DELETE requests
use Rack::MethodOverride

use UsersController
run ApplicationController
