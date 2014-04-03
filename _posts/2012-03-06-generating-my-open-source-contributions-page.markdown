---
layout: post
title: "Generating my open source contributions page"
date: 2012-03-06 15:38
categories: ruby github
---

As I was working on my [about](/about) page, I got tired of copying and pasting
the names of the pull requests and adding the link and so on. I wanted to
generate them dynamically, so I whipped up a quick script to do just that.

I decided I wanted to have a YAML file which had project paths as keys, and
pull request numbers as entries, which could later store the pull request
titles. I ended up with a file like this:

```ruby
# contribs.yml

---
brentd/gitploy:
  "1":
  "2":
philc/vimium: 
  "216":
cucumber/aruba: 
  "17":
  "19":
# and so on...
```

Now I wanted to take that file, fetch the title for each pull request and write
the changes back to the file. Really simple to do thanks to the awesome GitHub
API and the [Octokit gem](https://github.com/pengwynn/octokit):

```ruby
require 'yaml'
require 'octokit'

ROOT = File.expand_path('.', File.dirname(__FILE__))
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
```

Now that we've got projects, pull request numbers and pull request titles, we can update
the blog page:

```ruby
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
```
