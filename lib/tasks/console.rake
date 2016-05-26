desc 'Open IRB console for gem development environment'
task :console do
  require 'irb'
  require 'pocus'
  ARGV.clear
  IRB.start
end
