#! /usr/bin/ruby

# Start all the necessary servers running in the background
# Output from each is sent to appropriate files in the log folder
# Monitor with `tail -f log/<file>.log`

puts "Starting redis server..."
system 'redis-server ./redis.conf > log/redis.log &'

puts "Starting EventMachine server..."
system 'ruby server.rb > log/eventmachine.log &'

puts "Starting thin webserver..."
system 'ruby app.rb > log/thin.log &'

puts "Done."
