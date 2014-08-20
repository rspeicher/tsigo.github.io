---
title: "Ruby's Extended Regular Expressions"
categories: ruby regex
---

I recently [refactored][1] the custom Markdown parsing for [Gitlab][2], and I
thought I'd explain my primary reason for doing so:

```ruby
# match     1    2 3               4     5            6
text.gsub!(/(\W)?(@([\w\._]+)|[#!$](\d+)|([\h]{6,40}))(\W)?/) do |match|
  ...
end
```

Rule of thumb: if you ever find yourself adding a comment above the pattern to
number the match groups, the pattern is too complex for one line.

This is a perfect place to take advantage of Ruby's `x` delimiter for patterns:

```ruby
REFERENCE_PATTERN = %r{
  (\W)?              # Prefix (1)
  (                  # Reference (2)
    @([\w\._]+)    | # User name (3)
    [#!$](\d+)     | # Issue/MR/Snippet ID (4)
    [\h]{6,40}       # Commit ID (2)
  )
  (\W)?              # Suffix (5)
}x
```

So much easier to maintain and read.

[1]: https://github.com/gitlabhq/gitlabhq/commit/0456dd72e26aaba6455e851260426d0156ba159a
[2]: https://github.com/gitlabhq/gitlabhq
