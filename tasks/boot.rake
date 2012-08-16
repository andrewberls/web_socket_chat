require 'fileutils'

# Start all the necessary servers running in the background
# Output from each is sent to appropriate files in the log folder
# Monitor with `tail -f log/<file>.log`
#
task :start do
  log_dir = 'log'
  Dir.mkdir(log_dir) unless File.directory?(log_dir)

  %w(redis eventmachine thin).each do |name|
    logfile = "#{log_dir}/#{name}.log"
    unless File.exist?(logfile)
      puts "Creating logfile: #{logfile}"
      FileUtils.touch(logfile)
    end
  end

  puts "Starting redis server..."
  `redis-server ./redis.conf > log/redis.log &`
  save_pidfile('tmp/redis.pid')

  puts "Starting EventMachine server..."
  `ruby server.rb > log/eventmachine.log &`
  save_pidfile('tmp/eventmachine.pid')

  puts "Starting thin webserver..."
  `ruby app.rb > log/thin.log &`
  save_pidfile('tmp/thin.pid')

  puts "Done."
end


# Stop background server processes
#
task :stop do
  puts "Stopping redis server..."
  kill_from_pidfile('tmp/redis.pid')

  puts "Stopping EventMachine server..."
  kill_from_pidfile('tmp/eventmachine.pid')

  puts "Stopping thin webserver..."
  kill_from_pidfile('tmp/thin.pid')

  puts "Done."
end


# Crudely show the running server processes
# TODO: make this smarter
#
task :status do
  ignore_flags = %w(grep rake System).join('|')
  processes    = %w(redis server ruby).join('|')
  system "ps aux | grep -v -E '#{ignore_flags}' | grep -E '#{processes}'"
end


def save_pidfile(path)
  # Save the pid from the last process to a specified file
  pid_dir = File.dirname(path)
  Dir.mkdir(pid_dir) unless File.directory?(pid_dir)

  pid = `echo $$`.to_i - 1
  `echo #{pid} > #{path}`
end

def kill_from_pidfile(path)
  # Kill a process from a read pid
  pid = File.read(path)
  # TODO: if process_exists(ps) kill else ;
  `kill #{pid}`
end
