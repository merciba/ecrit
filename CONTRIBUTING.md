## Contributing Guidelines

So you want to get started developing Écrit? That's chill, we encourage open source contribution and really believe in the power of collaboration.  

Écrit is aimed at [readability](http://code.tutsplus.com/tutorials/top-15-best-practices-for-writing-super-readable-code--net-8118) and [separation of concerns](http://en.wikipedia.org/wiki/Separation_of_concerns). What do these mean in this context? Mainly, it's reflected in the initial design decisions.  

#### Literate Coffeescript - Markdown in your code, code in your markdown

[Literate Coffeescript] is the matrimonial union of the [CoffeeScript] parser and [Markdown] syntax.  
Literate Coffescript files use the file extension `.litcoffee`, and can be rendered as Markdown documents (Go ahead, copy any of the source code into a [Markdown parser](http://tmpvar.com/markdown.html)) and as Coffeescript files - in other words, `.litcoffee` renders as `.md` to `.html`, and `.litcoffee` compiles as `.coffee` to `.js`. Say that five times really fast.

Écrit is written almost entirely in Literate Coffeescript, because it means we can generate documentation HTML automatically using [Docco], and link back to other parts of the code. This means, put as many markdown comments in the code as possible. Link to articles relevant to the subject matter. Explain what's happening here, wherever in the codebase you are. These are the "principes d'Écrit".

#### Loaders Loaders Loaders


