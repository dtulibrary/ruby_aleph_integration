require 'ruby_aleph_integration'
require 'rails'
module AlephIntegration
  class Railtie < Rails::Railtie
    railtie_name :aleph_integration

    rake_tasks do
      load "tasks/ruby_aleph_integration.rake"
    end
  end
end
