require 'open-uri'

desc 'deploy'
task :deploy do
  sh 'bundle exec inesita build -f'
  sh 'cp dist/index.html dist/200.html'
  sh 'surge -p ./dist -d inesid.surge.sh'
end

desc 'Download HVSC SID Collection'
task :hvsc, [:hvsc] do |t, args|
  url = "http://www.prg.dtu.dk/HVSC/HVSC_#{args[:hvsc]}-all-of-them.zip"
  puts "Downloading HVSC collection from #{url}..."
end
