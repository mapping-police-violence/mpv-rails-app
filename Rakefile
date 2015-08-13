# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc "scrape lat long values from json file"
task :scrape => :environment do
  CsvImporter.scrape_lat_long_from_json
end
