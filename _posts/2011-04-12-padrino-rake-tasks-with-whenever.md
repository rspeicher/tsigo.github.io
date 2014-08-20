---
title: "Padrino Rake tasks with Whenever"
categories: ruby padrino whenever cron crontab
---

[Padrino](http://www.padrinorb.com/) as a framework is an interesting middle
ground between Rails and Sinatra. However, it breaks from the norm in that it
doesn't have a traditional Rakefile, opting instead to pass everything through
its `padrino` command (e.g., `padrino rake console`). Ordinarily this isn't a
problem, but it slightly conflicts with the excellent
[whenever](https://github.com/javan/whenever) gem for managing crontabs on a
production server, since whenever's default `rake` job type assumes there's a
traditional Rakefile.

Luckily whenever offers a simple solution by defining a custom `job_type`:

```ruby
# config/schedule.rb

job_type :padrino_rake, 'cd :path && padrino rake :task -e :environment'

every :hour do
  padrino_rake 'crawl'
end
```

Run after a deploy, my `crontab` will now look like this:

```sh
@hourly /bin/bash -l -c 'cd /path/to/my/project && padrino rake crawl -e production'
```
