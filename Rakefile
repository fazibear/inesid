require 'open-uri'
require 'json'
require 'pathname'

HVSC_PREFIX = './static/C64Music/'

desc 'deploy'
task :deploy do
  sh 'bundle exec inesita build -f'
  sh 'cp dist/index.html dist/200.html'
  sh 'surge -p ./dist -d inesid.surge.sh'
end

desc 'Download HVSC SID Collection'
task :hvsc, [:hvsc] do |t, args|
  mkdir_p "tmp"
  ver = args[:hvsc] || 64
  url = "http://www.prg.dtu.dk/HVSC/HVSC_#{ver}-all-of-them.zip"
  puts "Downloading HVSC collection from #{url}..."
  sh "curl #{url} > ./tmp/hvsc.zip"
  puts "Unzipping ..."
  sh "unzip -o ./tmp/hvsc.zip -d ./tmp"
  sh "unzip -o ./tmp/C64Music.zip -d ./static"
  rm_rf "tmp"
end

desc 'Index HVSC SID Collection List'
task :list do
  list = Dir["#{HVSC_PREFIX}**/*.sid"].map do |path|
    path = Pathname.new(path)
    [path.basename.to_s, path.to_s[1..-1]]
  end.sort do |a1,a2|
    a1.first <=> a2.first
  end
  File.write('./static/list.json', list.to_json)
end

desc 'Index HVSC SID Collection Tree'
task :tree do
  tree = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
  Dir["#{HVSC_PREFIX}**/*.sid"].each do |file|
    path = file.gsub('HVSC_PREFIX', '').split('/')
    name = path.pop
    path.inject(tree) {|h, k|
      h[k]
    }[name] = nil
  end
  File.write('./static/tree.json', tree.to_json)
end

task :index => [:list, :tree]

task :default => []
