# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

MediaServer::Application.load_tasks

task :server,[:mode] do |t,args|
	if (args.mode == "d") then
		puts "Starting development server"
		`bundle exec rails s -p 80 -d&`
	elsif (args.mode == "p") then
		puts "Starting production server"
		`thin start -p 80 -e production -d`
	end
end

desc 'stop rails'
task :stop, [:mode] do |t,args|
	if (args.mode == "d") then
		pid_file = 'tmp/pids/server.pid'
		pid = File.read(pid_file).to_i
		Process.kill 9, pid
		File.delete pid_file
	elsif (args.mode == "p") then
		`thin stop`
	end
end

desc 'add files location'
task :add_location, [:new_location] => [:environment] do |t, args|
    if (!args.new_location.nil?) then
		LocationsController.create(args.new_location)
	end
end

task :display_locations => [:environment] do
	LocationsController.display
end

task :remove_location, [:location_id] => [:environment] do |t,args|
	if (!args.location_id.nil?) then
		LocationsController.remove(args.location_id)
	end
end
