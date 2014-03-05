# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

MediaServer::Application.load_tasks

task :server do
  `bundle exec rails s -p 80 -d&`
end

desc 'stop rails'
task :stop do
    pid_file = 'tmp/pids/server.pid'
    pid = File.read(pid_file).to_i
    Process.kill 9, pid
    File.delete pid_file
end

desc 'add files location'
task :add_location, [:new_location] do |t, args|
    if (arts.add_location.nil?) then
        return
    end
    
    location = Location.new(location: new_location)
	   	location.location.gsub! "\\", "/"
		
		if location.save then
			files_controller = FilesController.new
			files_controller.gather(location)
		end
end
