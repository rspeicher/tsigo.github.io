---
layout: post
title: "Alphabetizing a block of text in Vim"
categories: vim
---

Today I had need to alphabetize a block of code in Vim, but on each line there
was text which I didn't want to be part of the sort. An example describes it
best:

    item 65110 #Heart of Ignacious
    item 65111 #Scepter of Ice
    item 65113 #Hydrolance Gloves
    item 65114 #Feludius' Mantle
    item 65115 #Glaciated Helm
    item 65116 #Treads of Liquid Ice
    item 65117 #Glittering Epidermis
    item 65118 #Crushing Weight
    item 65119 #Gravitational Pull
    item 65120 #Arion's Crown
    item 65121 #Terrastra's Legguards
    item 65122 #Dispersing Belt

Currently the lines are sorted numerically. I needed the lines to be sorted
alphabetically based on the content of the comments (the stuff after the `#`).
Vim made this stupid-easy:

1. Highlight the lines using visual line mode (`V`)
1. Run `:sort /.*#/`

Which gives us:

    item 65120 #Arion's Crown
    item 65118 #Crushing Weight
    item 65122 #Dispersing Belt
    item 65114 #Feludius' Mantle
    item 65115 #Glaciated Helm
    item 65117 #Glittering Epidermis
    item 65119 #Gravitational Pull
    item 65110 #Heart of Ignacious
    item 65113 #Hydrolance Gloves
    item 65111 #Scepter of Ice
    item 65121 #Terrastra's Legguards
    item 65116 #Treads of Liquid Ice

That's it. The argument to `sort` tells it to use everything **after** the
pattern. Beautiful.
