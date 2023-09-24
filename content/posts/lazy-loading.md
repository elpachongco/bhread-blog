---
title: "Lazy Loading with HTMX"
date: 2023-09-24T10:57:40+08:00
tags: ["htmx", "lazy-loading", "bhread"]
author: "Me"
showToc: true
TocOpen: false
draft: false
hidemeta: false
description: "Introducing lazy loading of posts in bhread's home page."
ShowRssButtonInSectionTermList: true
UseHugoToc: true
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: false # when using page bundles set this to true
#     hidden: true # only hide on current single page
---

Bhread now lazy loads posts!

## What is lazy loading? 

> Lazy loading is a technique for waiting to load certain parts of a webpage — especially images — until they are needed. 
> [source](https://www.cloudflare.com/learning/performance/what-is-lazy-loading/)

Visiting bhread.com will show 6 posts. If you reach the bottom of the page, it will load 8 more. The process repeats until
no more posts are found. This is also known as infinite scrolling.

## Why lazy load posts?

![lazy-loading-110kb](/images/lazy-loading-110kb.png)

Bhread.com loads a 100kb file when the home page is visited. This was because at the time of testing, the total numer of posts is around 30.
It loads all 30 of them in a single visit. This is a waste of bandwidth as most of the time, the user won't scroll far down anyway.

The 100kb file takes a long time to load (~1sec).

Now, it loads a 26kb file (still a bit big) in 350milsec. This is a big improvement in useability. It's the difference between snappy and sluggish.

![lazy-loading-26kb](/images/lazy-loading-26kb.png)

### Still supports no javascript

![lazy-loading-nojs-alt](/images/lazy-loading-nojs-alt.png)

Don't have javascript? You're still covered! Bhread will display a 'Next page' link so users without js can still use Bhread.


## How?

With HTMX, it's pretty easy.

First, send the user a list containing a list item with htmx:

`/home`:
```html
<ol>
    <li> {{ post id=1}} </li>
    <li> {{ post id=2}} </li>
    <li> {{ post id=3}} </li>
    <li> {{ post id=4}} </li>
    <li hx-get="/htmx-home?id=4" hx-trigger="intersect once" hx-swap="outerHTML" >
        {{ post-loading-skeleton }} 
    </li>
</ol>
```

What this does: render posts 1-4, then issue a get request to /htmx-home when the last element is seen by the user (intersect). Send the id of the last post.
If a response is received, replace THIS item  (li) with the new items.

Then, /htmx-home receives the id and returns the new posts which follow the id of the last post.

`/htmx-home?id=4`:
```html
<li> {{ post id=5 }} </li>
<li> {{ post id=6 }} </li>
<li> {{ post id=7 }} </li>
<li> {{ post id=8 }} </li>
<li hx-get="/htmx-home?id=8" hx-trigger="intersect once" hx-swap="outerHTML" >
    {{ post-loading-skeleton }} 
</li>
```

The resulting html is this:

```html
<ol>
    <li> {{ post id=1 }} </li>
    <li> {{ post id=2 }} </li>
    <li> {{ post id=3 }} </li>
    <li> {{ post id=4 }} </li>
    <li> {{ post id=5 }} </li>
    <li> {{ post id=6 }} </li>
    <li> {{ post id=7 }} </li>
    <li> {{ post id=8 }} </li>
    <li hx-get="/htmx-home?id=8" hx-trigger="intersect once" hx-swap="outerHTML" >
        {{ post-loading-skeleton }} 
    </li>
</ol>
```

The process continues until no more posts are found.


### Was this a good article?

For more updates, subscribe to the [bhread blog's RSS feed](https://blog.bhread.com/index.xml), visit [Bhread.com](https://bhread.com) or [join the discord server](https://blog.bhread.com/posts/bhread-discord-server/).

