---
title: Custom Video Server with Plex
categories: python flexget
---

This post is specifically about setting up a [Plex Media Server] section for
[Giant Bomb] videos, but may also be found useful for general information on
custom [Metadata Agents] and creating custom [Flexget] configurations.

### Goals

I've been a long-time fan of [Giant Bomb] video content and have been a
subscriber since its inception. Their videos can be long, ranging from 20
minutes to sometimes two hours, so I don't always watch the entire thing in one
sitting. Their on-site solution for resuming videos in progress has had some
issues: it used to be limited to a single video at a time, it saved position
locally in a cookie so it didn't work across multiple devices and clients, and
sometimes it was difficult to keep track of which videos I'd already watched and
which were new.

I decided I wanted to download all of the videos as they became available and
make them available on my local Plex server, which would help me keep track of
what content was already watched and what was in progress, as well as keep track
of my progress through the videos and make them available across all my
Plex-enabled devices (I watch in my browser, on two different Rokus, and on my
phone) with smart transcoding to lower quality on devices that require it.

### Downloading the videos

Before Plex can scan the video files, I need to download them somehow.

As a subscriber benefit, Giant Bomb provides several [RSS feeds] for their video
content. After looking at a few tools for downloading content from RSS feeds, I
decided to go with [Flexget], an extremely powerful tool that can do many more
things beyond what I'm using it for here.

I ended up with this configuration:

```yaml
# ~/.flexget/config.yml
templates:
  # Define options that will be used for all of our tasks below
  global:
    # Download path
    download: /fileserver/a/root/GiantBomb/

    # Don't filter
    accept_all: yes

    # We're storing the files on a Linux server, but they're shared over Samba,
    # so get rid of any characters that might interfere with that.
    pathscrub: windows

    # Rename the resulting file with the following format:
    #   [five-digit video id] - [title][extension]
    set:
      filename: '{{ "{{" }}comments|re_replace(".*\d{4}-(\d+)\/$", "\g<1>")|pad(5)}} - {{ "{{" }}title|pathscrub}}{{ "{{" }}filename|pathext}}'

    # Ignore duplicate files
    exists:
      - /fileserver/a/root/GiantBomb/

    # Don't re-download stuff we've downloaded and then deleted
    only_new: yes

    # Default login credentials (ignore the url, it gets changed below)
    # The "comments" field is included so that we can extract the video ID
    rss:
      url: http://local.host/
      other_fields: [comments]
      username: <REMOVED>
      password: <REMOVED>

tasks:
  quicklooks:
    rss:
      url: http://www.giantbomb.com/videos/feed/hd/3/

  subscriber:
    rss:
      url: http://www.giantbomb.com/videos/feed/hd/10/

  unfinished:
    rss:
      url: http://www.giantbomb.com/videos/feed/hd/13/

  bombastica:
    rss:
      url: http://www.giantbomb.com/videos/feed/hd/12/

  features:
    rss:
      url: http://www.giantbomb.com/videos/feed/hd/8/

    # These directives reject two regular video features that I don't care about
    # based on the video entry's title
    regexp:
      reject:
        - Bombin' the A.M.
        - Worth Playing
      from: title
```

I run Flexget every hour through cron:

```
0 * * * * /bin/bash -l -c 'flexget execute --cron'
```

### Setting up Plex

Installing and setting up Plex is [well documented], so I won't go into that
here. I'll start with installing my custom [Giant Bomb Agent] so that Plex will
match the downloaded videos and fill in details such as the proper title, the
"deck" (the summary of the video), and various other details.

```bash
% cd /home/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/
% git clone https://github.com/tsigo/GiantBomb.bundle.git
```

Then restart Plex to pick up the new agent.

```bash
% sudo service plexmediaserver restart
```

Access your Plex server via browser and go to **Settings** > **Server** >
**Agents**, and it should have a "Giant Bomb" section, like this:

![Agents](/assets/2014-08-20-Plex-Agents.png)

Click the gear icon to configure the agent and enter your Giant Bomb API key,
available [here][api key].

Now that the agent is installed and configured, let's add the video section. Add
a Library section like you would for other video content, select "Movies" as the
type of media, give it the folder that we configured in Flexget above, and under
Advanced, set the **Scanner** to "Plex Video Files Scanner" and the **Agent** to
"Giant Bomb". Save the section and let it scan. If you've downloaded some videos
already, it may look something like this:

![Videos](/assets/2014-08-20-Plex-Videos.png)

You can even use the advanced filters just like you would for a Movie or TV
Section to find videos you haven't yet watched, filter by Collection (e.g.,
Quick Look, Subscriber), and even the cast members (if their names are mentioned
in the summary.)

When you're done with a video just delete it from the folder and Plex will clean
up after itself on the next scan.

[Giant Bomb]: http://www.giantbomb.com/
[Plex Media Server]: https://plex.tv/
[Metadata Agents]: https://support.plex.tv/hc/en-us/articles/200241558-Agents
[Flexget]: http://flexget.com/
[RSS feeds]: http://www.giantbomb.com/feeds/
[well documented]: https://support.plex.tv/hc/en-us
[Giant Bomb Agent]: https://github.com/tsigo/GiantBomb.bundle
[api key]: http://www.giantbomb.com/api/
