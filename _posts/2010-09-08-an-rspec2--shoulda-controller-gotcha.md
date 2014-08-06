---
layout: post
title: "An RSpec2 / Shoulda Controller Gotcha"
categories: ruby rails rails3 rspec rspec2 shoulda
---

I'm in the process of upgrading a Rails 2.3.8 app to Rails 3, and part of that
process involved upgrading to [RSpec2](http://rspec.info/). I made use of
[Shoulda](https://github.com/thoughtbot/shoulda), mostly in my controller
tests, and I ran into a frustrating issue that hopefully I can prevent for
other people with this post.

A simple example controller spec looked like this:

```ruby
require 'spec_helper'

describe AchievementsController, "GET index" do
  before { get :index }

  it { should respond_with(:success) }
  it { should assign_to(:achievements).with_kind_of(Array) }
  it { should assign_to(:members).with_kind_of(Array) }
  it { should render_template(:index) }
end
```

Running this spec with RSpec2 generated this error:

```log
Failures:
  1) AchievementsController GET index
     Failure/Error: it { should respond_with(:success) }
     undefined method `response_code' for nil:NilClass
     # gems/activesupport-3.0.0/lib/active_support/whiny_nil.rb:48:in `method_missing'
     # (path)shoulda/lib/shoulda/action_controller/matchers/respond_with_matcher.rb:57:in `response_code'
     # (path)shoulda/lib/shoulda/action_controller/matchers/respond_with_matcher.rb:48:in `correct_status_code?'
     # (path)shoulda/lib/shoulda/action_controller/matchers/respond_with_matcher.rb:30:in `matches?'
     # ./spec/controllers/achievements_controller_spec.rb:12
     # gems/activesupport-3.0.0/lib/active_support/dependencies.rb:239:in `inject'

  2) AchievementsController GET index
     Failure/Error: it { should assign_to(:achievements).with_kind_of(Array) }
     Expected action to assign a value for @achievements
     # ./spec/controllers/achievements_controller_spec.rb:13
     # gems/ree-1.8.7-2010.02@rails3/gems/activesupport-3.0.0/lib/active_support/dependencies.rb:239:in `inject'

  3) AchievementsController GET index
     Failure/Error: it { should assign_to(:members).with_kind_of(Array) }
     Expected action to assign a value for @members
     # ./spec/controllers/achievements_controller_spec.rb:14
     # gems/ree-1.8.7-2010.02@rails3/gems/activesupport-3.0.0/lib/active_support/dependencies.rb:239:in `inject'
```

The solution is ridiculously simple:

```ruby
require 'spec_helper'

describe AchievementsController, "GET index" do
  before { get :index }
  subject { controller } # <- ADD THIS

  it { should respond_with(:success) }
  it { should assign_to(:achievements).with_kind_of(Array) }
  it { should assign_to(:members).with_kind_of(Array) }
  it { should render_template(:index) }
end
```

It makes perfect sense in retrospect, but it's a little frustrating that in
order to find this solution, I had to look through Shoulda's commit log for a
mention of rspec2, which noted a change to its Cucumber features, which
included this `subject` line.
