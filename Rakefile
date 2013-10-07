require 'yaml'
require 'octokit'

ROOT = File.expand_path('.', File.dirname(__FILE__))

task default: [:contribs, :markdown]

desc "Update contribs.yml file with issue names"
task :contribs do
  YAML_FILE = File.join(ROOT, '_includes', 'contribs.yml')

  puts
  puts "Updating _includes/contribs.yml"
  y = YAML.load(File.read(YAML_FILE))

  repos = y.keys.sort

  repos.each do |repo|
    y[repo].each_pair do |issue, title|
      if title.nil?
        y[repo][issue] = Octokit.pull(repo, issue).title
        puts "--> #{y[repo][issue]}"
      end
    end
  end

  File.open(YAML_FILE, 'w') { |f| f.write(y.to_yaml) }

  # Generates the open-source.md include file using data from contribs.yml
  puts "Generating _includes/open-source.md"

  y = YAML.load(File.read(YAML_FILE))

  File.open(File.join(ROOT, '_includes', 'open-source.md'), 'w') do |f|
    y.sort_by { |v| v[0] }.each do |pair|
      f.puts "#### [#{pair[0]}](https://github.com/#{pair[0]})"
      f.puts

      pair[1].each_pair do |issue, title|
        f.puts "* #{title} - [##{issue}](https://github.com/#{pair[0]}/pull/#{issue})"
      end

      f.puts
    end
  end
end

desc "Render custom markdown files"
task :markdown do
  ['open-source', 'projects'].each do |file|
    puts "Rendering _includes/#{file}.md"
    `redcarpet _includes/#{file}.md > _includes/#{file}.html`
  end
end
