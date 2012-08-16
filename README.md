## Web Socket Chat

This is a simple single-page chat application built to demo working with EventMachine, WebSockets, Backbone.js, and Redis. Original code by [Burwell Designs](https://github.com/nburwell/web_sockets)

### Quickstart
The servers listen on `localhost:4000`. You will need to run `bundle install` beforehand, as well as a redis installation.

### Task reference
```
rake build : Compile and concatenate all CoffeeScript source files
rake watch : Watch source files for changes and build on save
rake start : Start the redis, eventmachine, and thin servers
rake stop  : Stop server processes
```
