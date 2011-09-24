require 'rails/generators'

class MongoidTimelineFuGenerator < Rails::Generators::Base
  source_root File.expand_path("../../templates", __FILE__)

  def create_migration_file
    copy_file 'model.rb', 'app/models/timeline_event.rb'
  end
end
