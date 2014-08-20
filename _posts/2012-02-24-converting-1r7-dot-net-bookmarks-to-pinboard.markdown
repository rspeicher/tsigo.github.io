---
title: "Converting 1r7.net bookmarks to Pinboard"
categories: ruby
---

When [Delicious](http://delicious.com/) originally shut down, [Chris Heald](https://twitter.com/cheald)
whipped up a site called [1r7](http://1r7.net) to pick up its slack. I used it
for a while, but recently discovered [Pinboard](https://pinboard.in) and wanted
to move over my bookmarks from 1r7. The bad news was that 1r7's export feature
was throwing a 500 error for me, but the good news was that between 1r7's
semantic markup and Pinboard's API, it was crazy simple to write a quick script
to transfer them.

```ruby
#!/usr/bin/env ruby

require 'cgi'
require 'nokogiri'

api_base = "https://user:pass@api.pinboard.in/v1/posts/add"

# Pre-assumes that you've exported each HTML page of your 1r7 bookmarks to
# "1r7p1.html", "1r7p2.html", "1r7p3.html", etc.
1.upto(2) do |page|
  doc = Nokogiri::HTML(File.read("1r7p#{page}.html"))

  # Extracts bookmark data; note that '1r7' is added to each bookmark's tags
  # for easier filtering on Pinboard
  doc.css('#content li').each do |li|
    args = {
      url:         li.at_css('h1 a')['href'],
      description: li.at_css('h1 a').content,
      extended:    li.search('q').text.strip,
      tags:        (li.css('span.tags span.tag a').collect(&:content) << '1r7').join(' '),
      dt:          li.at_css('time')['datetime']
    }

    # Map our arguments to a query string
    q = "?" + args.map {|k,v| "#{k}=#{CGI::escape(v)}" }.join('&')

    `curl "#{api_base}#{q}"`
  end
end
```
