require 'open-uri'
require 'json'
require 'pathname'

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

desc 'Index HVSC SID Collection'
task :index do
  flat = Dir['./static/music/**/*.sid'].map do |path|
    path = Pathname.new(path)
    [path.basename.to_s, path.to_s[1..-1]]
  end.sort do |a1,a2|
    a1.first <=> a2.first
  end.to_json
  File.write('./static/music/flat.json', flat)
end
