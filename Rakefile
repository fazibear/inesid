require 'open-uri'
require 'json'
require 'pathname'

HVSC_PREFIX = './static/C64Music/'

task default: [:hvsc, :index, :build]

desc 'build'
task :build do
  sh 'bundle exec inesita build -f'
end

desc 'Download HVSC SID Collection'
task :hvsc, [:hvsc] do |_, args|
  mkdir_p "tmp"
  ver = args[:hvsc] || 79
  url = "https://hvsc.brona.dk/HVSC/HVSC_#{ver}-all-of-them.rar"
  puts "Downloading HVSC collection from #{url}..."
  sh "curl #{url} > ./tmp/hvsc.rar"
  puts "Unzipping ..."
  sh "unrar x -y ./tmp/hvsc.rar ./static"
  rm_rf "tmp"
end

desc 'Index HVSC SID Collection List'
task :list do
  list = Dir["#{HVSC_PREFIX}**/*.sid"].map do |path|
    path = Pathname.new(path.gsub(HVSC_PREFIX, ''))
    [path.basename.to_s, path.to_s]
  end.sort do |a1,a2|
    a1.first <=> a2.first
  end
  File.write('./static/list.json', list.to_json)
end

desc 'Index HVSC SID Collection Tree'
task :tree do
  tree = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
  Dir["#{HVSC_PREFIX}**/*.sid"].sort.each do |file|
    path = file.gsub(HVSC_PREFIX, '').split('/')
    name = path.pop
    path.inject(tree) {|h, k|
      h[k]
    }[name] = nil
  end
  File.write('./static/tree.json', tree.to_json)
end

task :index => [:list, :tree]

task :deploy => [:hvsc, :index, :build]
