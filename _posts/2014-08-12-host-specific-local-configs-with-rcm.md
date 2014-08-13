---
layout: post
title: Host-specific .local configs with RCM
date: 2014-08-12 21:00
categories: shell
---

A few months ago I experimented with managing my [dotfiles] with thoughtbot's
[rcm]. The change was positive, but I felt that I was duplicating a lot of the
conventions and functionality of [thoughtbot's dotfiles]() without any of the
advantages an actual fork would get such as upstream changes and peer review.

So I started fresh, aiming to make changes to my dotfiles only where they
differed from thoughtbot's. They make this easy with a convention of using
[.local files][locals], but I ran into a problem when I had a `zshrc.local` file
that also needed to be appended with some host-specific settings on just one of
my machines.

A file at `host-mycomputer/zshrc.local` would be ignored because I already had a
non-host-specific `zshrc.local` file in my dotfiles. The solution ended up being
pretty simple, but without some basic Bash scripting knowledge it seems a bit
like magic.

First, I kept my more generic `zshrc.local` file as it was, and moved the
host-specific configuration to `host-mycomputer/zshrc.mycomputer.local`,
resolving the name conflict.

The next step was to get the host-specific file to be read and processed. It's
similar but not identical to thoughtbot's [convention] of bringing in `.local`
files. I modified my `zshrc.local` file to have this at the bottom:

```bash
# Host-specific local configs (e.g., ~/.zshrc.laptop.local)
set -- ~/.zshrc.*.local
[ "$#" -gt 0 ] && source "$@"
```

And this works. But why? Well, the first line (ignoring the comment) tells the
script to assign the command-line arguments (the `--`, see [double dash]) to any
file(s) matching `~/.zshrc.<something>.local`. The second line checks if there's
at least one match, and `source`s all of them at once (`"$@"` expands to `"$1"
"$2" "$3" ...`)

This allowed me to have my local zshrc configuration, as well as some
host-specific settings that only applied when I was on my main development
machine.

You can see this in action
[here](https://github.com/tsigo/dotfiles-local/blob/master/zshrc.local) and
[here](https://github.com/tsigo/dotfiles-local/blob/master/host-pride/zshrc.pride.local).

[convention]: https://github.com/thoughtbot/dotfiles/blob/master/zshrc#L78-L79
[dotfiles]: https://github.com/tsigo/dotfiles-rcm
[double dash]: http://unix.stackexchange.com/questions/11376/what-does-double-dash-mean-also-known-as-bare-double-dash
[locals]: http://robots.thoughtbot.com/manage-team-and-personal-dotfiles-together-with-rcm
[rcm]: https://github.com/thoughtbot/rcm
