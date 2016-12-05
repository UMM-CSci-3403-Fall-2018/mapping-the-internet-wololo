# Lab 11: Mapping out (small parts of) the Internet

[![sample map](maps/sample-map.png)](maps/sample.png)

-   [Lab 11: Mapping out (small parts of) the
    Internet](#Lab_11_Mapping_out_small_parts_o)
-   [Background](#Background)
-   [traceroute](#traceroute)
-   [DOT/Graphiv](#DOT_Graphiv)
-   [Run traceroute on several different
    destinations](#Run_traceroute_on_several_differ)
-   [Generating graphs](#Generating_graphs)
-   [Sharing your results](#Sharing_your_results)
-   [Groups and results](#Groups_and_results)


## Background

Since this is a short week at the end of the semester, my plan is for this lab
to be self-contained, and hopefully a bit of fun. What we're going to do
is use the `traceroute` command and the `dot` graph drawing tool (part
of the [graphiv package](http://www.graphviz.org/)) to map out some
sections of the Internet as it is visible to us here in the lab. Your
task is to run `traceroute` on several different target hosts around the
world, which exposes a few (a tiny subset, actually) of the routing
paths that exist on the Internet. You'll then massage those results into
a format that you can feed the DOT tool, and DOT can draw pretty graphs
(such as the one on the right).

And you should check out [this cool xkcd comic](http://xkcd.com/195/)
which shows the allocation of top level domains as of 2006. The U.S. has
a *lot* of IP addresses...

## `traceroute`

The `traceroute` command takes a destination hostname or an IP address
as an argument, and attempts to infer the route packets take from your
computer to the specified destination. As an example, below is the
result of running `traceroute` from one of the lab machines to mit.edu.
The first 13 steps are the "standard" route from UMM to the connection
to the "rest of the world" on the Twin Cities campus. From there we see
the (less predictable) results of routing from there to our destination.
The lines with just '\*'s (19-30) are presumably internal routing points
within MIT that are configured not to reveal their details to outsiders;
when I run `traceroute` from the UK back to our lab, all the routing
boxes in steps 3-9 below show up as just '\*'s.

    traceroute to mit.edu (18.9.22.69), 30 hops max, 60 byte packets
     1  starship33.morris.umn.edu (146.57.33.254)  0.366 ms  0.394 ms  0.435 ms
     2  mrs-cb-01-gi-1-26.250.ggnet.umn.edu (146.57.237.1)  1.519 ms  1.899 ms  1.917 ms
     3  172.25.0.125 (172.25.0.125)  7.176 ms  7.143 ms  7.089 ms
     4  172.25.0.126 (172.25.0.126)  7.038 ms  7.002 ms  7.230 ms
     5  172.25.0.118 (172.25.0.118)  7.196 ms  7.165 ms  7.561 ms
     6  172.25.0.102 (172.25.0.102)  7.525 ms  7.604 ms  7.610 ms
     7  172.25.1.90 (172.25.1.90)  6.776 ms  7.142 ms  7.311 ms
     8  172.25.1.178 (172.25.1.178)  7.515 ms  7.527 ms  7.792 ms
     9  172.25.0.38 (172.25.0.38)  7.726 ms  7.940 ms  7.907 ms
    10  telecomb-bn-02-v3230.ggnet.umn.edu (146.57.238.49)  8.478 ms  8.441 ms  8.389 ms
    11  telecomb-br-02-v3239.ggnet.umn.edu (146.57.238.50)  7.226 ms  7.402 ms  7.387 ms
    12  telecomb-br-01-te-4-2.ggnet.umn.edu (192.35.86.29)  7.233 ms  7.375 ms  7.139 ms
    13  telecomb-gr-01-ten-2-3.northernlights.gigapop.net (146.57.252.178)  7.188 ms  6.944 ms  7.496 ms
    14  infotech-gr-01-te-2-1.northernlights.gigapop.net (146.57.252.129)  7.501 ms  7.464 ms  7.428 ms
    15  nlr.northernlights.gigapop.net (192.35.86.170)  19.790 ms  19.767 ms  19.730 ms
    16  newy-chic-100.layer3.nlr.net (216.24.186.33)  42.789 ms  42.714 ms  42.674 ms
    17  216.24.184.102 (216.24.184.102)  41.155 ms  41.588 ms  41.529 ms
    18  OC11-RTR-1-BACKBONE-2.MIT.EDU (18.168.1.41)  47.050 ms  47.228 ms  47.230 ms
    19  * * *
    20  * * *
    21  * * *
    22  * * *
    23  * * *
    24  * * *
    25  * * *
    26  * * *
    27  * * *
    28  * * *
    29  * * *
    30  * * *

## DOT/Graphiv

[Graphiv](http://www.graphviz.org/) is a very cool set of tools for
generating graphs described in a simple text format. As a very simple
example, consider the following input file `example.dot`:

    digraph example {
       A -> B;
       B -> C;
       A -> C;
       A -> D;
       B -> E;
    }

Running `dot -Tpng example.dot -o example.png` will then generate the
graph below.

![Simple example DOT
graph](rsrc/UmmCSci3401f09/LabEleven/example.png){width="252"
height="251"}

In the example file the line `digraph example` tells DOT that you're
making a *directed* graph named "example". (The name doesn't really
matter much.) The lines below are all directed edges from the label on
the left to the label on the right. In the command the flag `-Tpng`
tells DOT to write out in PNG format. DOT knows a number of graphics
formats, and for *big* graphics (like the ones we'll be generating here)
PDF ( *not* PNG) is probably the most sensible choice. PDF will scale up
and down better for zooming in, and the generated PDF files for large
graphs are *much* smaller than the generated PNG files.

## Run traceroute on several different destinations

We'd like to explore as many different routings as possible, so we want
to run routes to as many different places as possible. Each group is
free to choose to explore destinations as you wish, but you should *at
least* include:

-   A "big name" `.com` destination
    -   It's OK if multiple people hit the same one, because it might
        reveal something useful about how big "cloud computing"
        infrastructures are routed.
-   A `.gov` destination
-   A `.org` destination
-   At least one non-US destination
    -   It can be tricky to know for sure where something is actually
        hosted; I would recommend trying to go to university domains
        since they're almost always run internally (and
        therefore locally).
    -   It would be nice if the class collectively has at least one
        destination on each of the continents.

Run `traceroute` on several different destinations and go through the
output. Feel free to ask questions and point out interesting tidbits
that you discover!

## Generating graphs

Given the output of `traceroute` and the format of DOT files, it's a
fairly straightforward (if somewhat tedious) task to convert the
`traceroute` output into a DOT file. Rather than have you wade through
that, I'm providing you with a Ruby script (based on a script from a few
years ago by Melissa Helgeson) that runs `traceroute` and generates the
corresponding DOT file. The script is in
`~mcphee/pub/CSci3401/TraceRouteLab/tracerouteDot.rb`. It takes one or
more domain names as command line arguments, runs `traceroute` on each
of those domains, parses the results, and generates the DOT bits. The
output is written to `network_graph.dot`. Running the script can take a
while depending on the number of domains and how many hops are necessary
to get from here to there.

Run the script on your set of domain names, and then run DOT on the file
it generates, i.e.,

       dot -Tpdf -o network_graph.pdf network_graph.dot

Look over the resulting graph. Again, ask questions and share cool stuff. :sunglasses:

You should also look at the DOT file that the script generates, which
might look something like this:

    digraph network {

    // Dungeon -> xps1.essex.ac.uk (a computer I use in Britain)
    "Dungeon" -> "starship33.morris.umn.edu (146.57.33.254)";
    "starship33.morris.umn.edu (146.57.33.254)" -> "mrs-cb-01-gi-1-26.250.ggnet.umn.edu (146.57.237.1)";
    "mrs-cb-01-gi-1-26.250.ggnet.umn.edu (146.57.237.1)" -> "172.25.0.125 (172.25.0.125)";
    "172.25.0.125 (172.25.0.125)" -> "172.25.0.126 (172.25.0.126)";
    "172.25.0.126 (172.25.0.126)" -> "172.25.0.118 (172.25.0.118)";
    "172.25.0.118 (172.25.0.118)" -> "172.25.0.102 (172.25.0.102)";
    "172.25.0.102 (172.25.0.102)" -> "172.25.1.90 (172.25.1.90)";
    "172.25.1.90 (172.25.1.90)" -> "172.25.1.178 (172.25.1.178)";
    "172.25.1.178 (172.25.1.178)" -> "172.25.0.38 (172.25.0.38)";
    "172.25.0.38 (172.25.0.38)" -> "telecomb-bn-02-v3230.ggnet.umn.edu (146.57.238.49)";
    "telecomb-bn-02-v3230.ggnet.umn.edu (146.57.238.49)" -> "telecomb-br-02-v3239.ggnet.umn.edu (146.57.238.50)";
    "telecomb-br-02-v3239.ggnet.umn.edu (146.57.238.50)" -> "telecomb-br-01-te-4-2.ggnet.umn.edu (192.35.86.29)";
    ...
    "gi0-1.colc-rbr1.eastnet.ja.net (193.63.107.41)" -> "essex.site.ja.net (193.60.0.210)";
    "essex.site.ja.net (193.60.0.210)" -> "155.245.47.186 (155.245.47.186)";
    "155.245.47.186 (155.245.47.186)" -> "xps.essex.ac.uk";

    // zeus -> google.com
    "zeus" -> "starship33.morris.umn.edu (146.57.33.254)";
    "starship33.morris.umn.edu (146.57.33.254)" -> "mrs-cb-01-gi-1-26.250.ggnet.umn.edu (146.57.237.1)"
    "mrs-cb-01-gi-1-26.250.ggnet.umn.edu (146.57.237.1)" -> "172.25.0.125 (172.25.0.125)";
    "172.25.0.125 (172.25.0.125)" -> "172.25.0.126 (172.25.0.126)";
    ...

A few things to note:

-   This uses the "hostname (IP address)" part of the traceroute output
    as the node name. This is unique, so if two routes pass through the
    same host, DOT will only create one node there, and run multiple
    edges to/from it. (See, for example, the initial sequence coming
    from zeus in the graph on the top right.)
-   We need to put quotes around your node names. If they're simple like
    X or Y, you don't need the quotes, but since our nodes have all
    kinds of odd characters and white space, we need to quote them.
-   For each adjacent pair of IPs in the `traceroute` output, the script
    creates an edge in the DOT file.
-   The script adds "fake" nodes at the beginning and end of the graph
    so there's a clear label for the starting and ending point. The
    starting point doesn't show up in the `traceroute` output, and the
    ending point doesn't always show up in the form that you typed when
    calling `traceroute`, so including them will make it easier for us
    to figure out what we're looking at when we combine all the results
    into a really big graph.
    -   ![ALERT!](rsrc/System/DocumentGraphics/warning.gif "ALERT!"){width="16"
        height="16"} Instead of using your "real" host, the script marks
        the starting node as "Dungeon". This way all the graphs will
        join up regardless of which client you're on.
-   Comments are allowed in DOT files using either the `//` or the
    `/* */` forms.
-   Indentation doesn't matter.
-   You can have multiple `traceroute` outputs in the same file, and
    `dot` will connect up the different sub-graphs as appropriate, or
    leave them disconnected if they never join up.
    -   This means that we can take a bunch of different DOT files from
        different groups, and with very little effort generate one big
        DOT file that will make a really nifty, big graph :-).

## Sharing your results

-   Clone (***do not fork!***) the lab Github repo:
    <https://github.com/UMM-CSci-3401-F13/Mapping-the-Internet>
-   Add your DOT file(s) to your clone, commit, and push them up
    to Github. This will allow anyone who wants to see the full set to
    do a `git pull` on their clone and get all the current files.
    -   ![ALERT!](rsrc/System/DocumentGraphics/warning.gif "ALERT!"){width="16"
        height="16"} Commit what you have right away, and then continue
        to commit new versions as you go. If you commit early and modify
        from there, I can start right away on building a single
        composite graph with everyone's results in one (probably
        very large) graph. My goal is to have a draft of the Big Graph
        done in lab for everyone to look at at the end of class.
-   Add your group and your target destinations you ran `traceroute` on
    to the README page on the Github repo.
    -   You can either add the copy of the README that you got in your
        clone and commit and push that, or you can edit the README
        directly on Github via their web interface.

## Groups and results

I'll let you self-assemble today in groups of no more than two people.
Remember to list your group and which domains you traced routes to in
the repo README file.

-- [NicMcPhee](../../Main/NicMcPhee.html) - 21 Nov 2011\
-- Main.lamberty - 27 Nov 2012\
-- [JohnMcCall](../../Main/JohnMcCall.html) - 06 Nov 2013\
-- [NicMcPhee](../../Main/NicMcPhee.html) - 21 Nov 2013
