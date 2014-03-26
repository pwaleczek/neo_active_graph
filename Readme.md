# NeoActiveGraph
[![Build Status](https://travis-ci.org/pwaleczek/neo_active_graph.svg?branch=master)](https://travis-ci.org/pwaleczek/neo_active_graph)
An ActiveRecord-like [Neography](https://github.com/maxdemarzi/neography) wrapper.

The aim is to get as close as possible to the Active Record usage metods as possible. This gem relies on the Neo4j REST API. No JRuby! Yay!!

## Installation
It's an early WIP. Install from here only at the moment.

## Configuration

Configure Neography separately [like here](https://github.com/maxdemarzi/neography/wiki/Configuration-and-initialization)
then in the same initializer do

__OR__

just use the quick init method

```ruby

NeoActiveGraph.configure "http://user:pass@some-host.com:7474"

```

### TO-DO
- lots of stuff

##License

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE Version 2, December 2004

Copyright (C) 2013 Paweł Waleczek pawel@thisismyasterisk.org

Everyone is permitted to copy and distribute verbatim or modified copies of this license document, and changing it is allowed as long as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

You just DO WHAT THE FUCK YOU WANT TO.
