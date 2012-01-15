#!/usr/bin/env ruby
# watch.rb by Brett Terpstra, 2011 <http://brettterpstra.com>
# with credit to Carlo Zottmann <https://github.com/carlo/haml-sass-file-watcher>
# original by Brett Terpstra <http://brettterpstra.com/watch-for-file-changes-and-refresh-your-browser-automatically/>
# fork by Vaclav Vancura / SAY Media <http://saymedia.com>

# Updated: Dan Woodward, to work with less and bootstrap make file structure.


# Run this via screen
# cd into static directory.
# $ screen
# $ ruby lib/watch.rb
# // OPTIONAL
# // to detach the screen task and close the shell
# $ ctrl a, ctrl d 
# // get back to the screen task.
# $ screen -r 
 
trap("SIGINT") { exit }
 
filetypes = ['less']
watch_folder = 'lib'
puts "Watching #{watch_folder} and subfolders for changes in project files..."
 
while true do
  files = []
  
  filetypes.each {|type|
    files += Dir.glob( File.join( watch_folder, "**", "*.#{type}" ) )
  }
  
  new_hash = files.collect {|f| [ f, File.stat(f).mtime.to_i ] }
  hash ||= new_hash
  diff_hash = new_hash - hash
 
  unless diff_hash.empty?
    hash = new_hash
 
    diff_hash.each do |df|
      puts "Detected change in #{df[0]}, refreshing"

			# Run the Makefile in the project directory
      %x{make}

			# Print the output from the make file 
			res = `make`
			puts res      
    end
  end
 
  sleep 0.2
end