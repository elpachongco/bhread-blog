---
title: "Soon"
date: 2023-11-04T10:01:50+08:00
tags: ["feature"]
author: "elpachongco"
showToc: true
TocOpen: true
draft: false
hidemeta: false
description: "Planned features of Bhread."
ShowRssButtonInSectionTermList: true
UseHugoToc: true
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: false # when using page bundles set this to true
#     hidden: true # only hide on current single page
---

I'm in the middle of (slowly) developing the new version of bhread. Some ideas
pop up in my head while developing. Some are new, some are old but I have
forgotten.

See table of contents for outline, details in their sections. These are sorted
by priority, high (top) to low.

## An embeddable comment section

Before I started creating Bhread, I was looking for a comment section solution
for my blog. I couldn't find anything good enough. There was Disqus which feels
too bloated to me design-wise. I might be wrong, there may be some possible
customizations but I didn't bother to try when I heard of some privacy concerns
people have over it.

The other alternative is to use github for comments. It may be a viable solution
but the fact that it depends on github feels unnatural to me.

Sometimes, comments can be valuable. As an internet user, you'll benefit having
these kinds of small details from comments being exposed to the world.

My proposal is to allow blogs that participate in bhread to enable each post of
a blog to have a section that will display replies from other blogs for each
post.

## Per-post RSS Feed

Notifications are complex. Rss feeds can handle that. The plan is to add an rss
feed for each post so that anyone can "follow" the post even without an account.
This makes your notifications opt-in which you may or may not want.

## Set polling time of feed if verified

I want to enforce politeness into hubs as much as I can. I plan on letting users
with verified accounts to control the interval of scanning of each of their
feeds. As I write this, I realized this setting must also be exposed to other
hubs. Maybe, I shouldn't bother with this. Maybe this belongs to the Atom or RSS
feed spec.

## List of invalid feeds

Moderation will be a problem. We want to keep a list of invalid feeds that other
hubs and possibly other services may use. This list will be useful for
identifying which feeds are not direct sources.

## List of valid feeds

I'm not too keen on implementing this. But the plan is to expose an endpoint
that lists all the feeds that the hub is scanning. This works in combination
with the invalid feeds list.

## Authentication

Sign in to a different hub from a hub Not sure if this should be implemented
because we could expose a list of registered feeds anyway.

The idea is to allow any hub to spawn a new window to a bhread login page. On
successful login, the window will emit an event containing auth information.
This way, accounts work accross all hubs. The problem I see is that one cannot
be fully certain of how other hubs will implement this plus the difficulty of
making this secure and maintaining it makes me want to not pursue this.
