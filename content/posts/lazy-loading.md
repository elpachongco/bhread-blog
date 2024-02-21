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


## How about noJS?

The good thing about HTMX is that it allows the site to degrade well when JS is disabled. It's a bit more complicated to implement but I expect Bhread to deal with mostly static sites. Ones that don't need JS to function. So I think it's worth the effort to implement this. Your mileage may vary.

To outline how this is implemented, here's a rough step-by-step:
- In the backend, detect if request is coming with an HTMX request header. If not present, the user has JS disabled.
- In the frontend, add a `<noscript>` tag that includes a button labeled 'next'. This button should include the ID of the last item that was rendered.
- When generating the html, check if JS is enabled in the request. 
- If yes, add the htmx-enabled element that will request for new items when seen
- If not, don't add anything.
- The `<noscript>` element will still be present whether JS is on or not. We don't need to worry about this because it takes advantage of the fact that this block will not be shown unless JS is disabled.
- Now make both `/home` and `/htmx-home` accept an ID argument which is the ID of the last element rendered.
- If JS is enabled, use the route for htmx: `/htmx-home`, passing the ID and returning a new list of partials that continues from the ID
- The client receives this and appends it to the current list of items.
- If JS is disabled, use the normal route for the home page `/home`, passing the ID and returning a new page containing the new items that follow the ID.
- When the button for 'next page' is pressed, the page will reload containing the new posts and another 'next page' button.

If you're interested in this, the code is FOSS, the backend code for this is here:

[views.py](https://github.com/elpachongco/bhread/blob/main/bhread/feed/views.py#L24)

and the HTML template is here:

[home.html](https://github.com/elpachongco/bhread/blob/main/bhread/feed/templates/feed/home.html#L30)


## Stay updated

For more updates, subscribe to the [bhread blog's RSS feed](https://blog.bhread.com/index.xml), visit [Bhread.com](https://bhread.com) or [join the discord server](https://blog.bhread.com/posts/bhread-discord-server/).
