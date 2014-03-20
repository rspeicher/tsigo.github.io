#### [gitlab](https://github.com/gitlabhq/gitlabhq)

Since 2012 I've volunteered as a [contributor][contributor] to the popular
[GitLab][gitlab] project, focusing mainly on cleaning up the existing code,
adding requested features and triaging tickets.

Over [60 merged pull requests][pulls] and counting!

[contributor]: http://contributors.gitlab.org/contributors/robert-speicher/commits
[gitlab]: http://www.gitlab.com/
[pulls]: https://github.com/gitlabhq/gitlabhq/pulls/tsigo?direction=desc&page=1&sort=created&state=all

#### [video_dimensions](https://github.com/tsigo/video_dimensions)

Quick and easy video attributes -- width, height, bitrate, codec, duration,
framerate.

**Tools used:** Ruby, RSpec

#### [hubstar](https://github.com/tsigo/hubstar)

HubStar <strike>provides</strike> provided the missing "star" feature for
GitHub repositories.

I was tired of my activity feed being clogged by projects I watched to remember
for later, but wasn't actively interested in things like their day-to-day
pushes and issue changes.

I had been using the Gitmarks Chrome extension for a while, but the problem was
that it only displayed the name of the project, which can sometimes be pretty
ambiguous, and I had trouble finding what I was looking for when I came back to
find it later. HubStar solves that issue by displaying more information about
the projects that I save.

**Tools used:** Ruby 1.9, Rails 3.2, Heroku, PostgreSQL, OmniAuth, GitHub
OAuth, Octokit, CoffeeScript, jQuery, Twitter Bootstrap, RSpec, FactoryGirl,
Shoulda

#### [gemphile](https://github.com/tsigo/gemphile)

A Gemfile and gemspec indexer

For some developers, the best way to learn how to use a gem is to see how other
projects use it in the real world. But what if you can't easily find a project
that uses the gem you're trying to learn about? Gemphile was created to index
the Gemfiles and gemspecs of Ruby projects on GitHub and then to provide a
simple search interface to find those projects.

**Tools used:** Ruby 1.9, Sinatra, MongoDB, Mongoid, Mustache, DelayedJob,
RSpec, FactoryGirl, WebMock, GitHub API v2

#### [wriggle](https://github.com/tsigo/wriggle)

A simple Ruby directory crawler DSL

**Tools used:** Ruby, RSpec, TravisCI

#### [invision_bridge](https://github.com/tsigo/invision_bridge)

Allows your Authlogic-based User model to authenticate using an IP.Board 3.x database.

**Tools used:** Ruby, ActiveRecord, Authlogic

#### [wowr](https://github.com/tsigo/wowr) - forked from [pwood](https://github.com/pwood/wowr)

Originally this gem's code was monolithic with few if any meaningful tests and
absolutely no API documentation. Together with [Tanner Donovan][ttdonovan], I
documented nearly all of the API, added nearly total test coverage and
refactored the code into smaller, logical chunks while maintaining backwards
compatibility with the legacy API.

[ttdonovan]: https://github.com/ttdonovan
