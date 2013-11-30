lissio - e vai col lissio
=========================
**lissio** is a VCL (Vai Col Lissio) framework for [Opal](http://opalrb.org) to
implement frontends completely on the client side.

Application
-----------
Every **lissio** frontend begins with an `Application` singleton.

A `Lissio::Application` singleton is a `Lissio::Component` that takes ownership
of the `body` element and renders itself on it, since it's just a component you
can do anything you can do with any other component.

It also internally creates a router, so you can define the routes and what they
do directly in the `#initialize` method.

```ruby
class MyApplication < Lissio::Application
  def initialize
    super

    route '/' do
      alert "This is an awesome index, ain't it?"
    end

    route '/about' do
      alert "I don't know you, you don't know me"
    end
  end
end
```

Component
---------
Components are the heart of any lissio application, in the MVC pattern a lissio
component would be a mix of a view and a controller.

Every component has the ability to define the HTML, the CSS and the behaviour
in pure Ruby using various DSLs.

```ruby
class MyComponent < Lissio::Component
  tag class: 'my-component'

  on :click, '.title' do
    alert 'You clicked on the title'
  end

  on :hover, '.subtitle' do
    alert 'You hovered over the subtitle'
  end

  html do
    div.title 'hue'
    div.subtitle 'huehuehuehue'
  end

  css do
    rule '.my-component' do
      rule '.title' do
        font size: 32.px
      end

      rule '.subtitle' do
        font size:  18.px,
             style: :italic
      end
    end
  end
end
```

Every component has a `#render` method, once it's called it will create an
element based on the `#tag` definition or render itself in the defined
`#element`.

On rendering the `#html` DSL block will produce the DOM directly, there won't
be any generate-parse passes, and the `#css` block will generate the CSS style
and put it in the `<head>`

Model
-----
Models are the classic models, they have properties and can be populated using
adapters.

```ruby
class Message < Lissio::Model
  property :id, as: Integer, primary: true
  property :at, as: Time, default: -> { Time.now }
  property :content, as: String
end
```

You can then instantiate the model `Message.new(id: 2, content: "huehue")`.

Collection
----------
Collections are, well, collections of models, they're separate entities since
they can have different adapters and have different methods of fetching or
working on the models they contain.

```ruby
class Messages < Lissio::Collection
  model Message
end
```

Adapter
-------
Without adapters models and collections would be pretty much useless since you
wouldn't be able to persist them.

When you define a model you can set an adapter calling the `#adapter` method.

**lissio** comes with two default adapters, REST and localStorage, they take
various options to define endpoints and other behaviour.

```ruby
class Message < Lissio::Model
  adapter Lissio::Adapter::REST, endpoint: '/message'

  property :id, as: Integer, primary: true
  property :at, as: Time, default: -> { Time.now }
  property :content, as: String
end
```

Now you'll be able to fetch a model like this.

```ruby
Message.fetch(1) {|msg|
  if Message === msg
    alert msg.content
  else
    alert msg.inspect
  end
}
```

When you do operations using adapters you'll always have to provide a block
that will be called, since all operations are asynchronous.

The class check is done because the block will be either passed the model or an
error.

Server
------
**lissio** comes with a server to run and provide the built application, you're
not forced to use it, but it provides seamless access to the HTML5 history.

This means it always gives you the index when accessing any URL that isn't a
static file.

In the future it will do prerendering using phantomjs to make **lissio**
applications indexable and crawlable by search engines, so you might want to
stick with it.

Following an example on how to run the server.

```ruby
require 'bundler'
Bundler.require

run Lissio::Server.new {|s|
	s.append_path 'app'
	s.append_path 'css'
	s.append_path 'js'

	s.index = 'index.html.erb'
	s.debug = true
}
```

The application usually goes in `app/`.

External CSS should go in `css/`, usually you don't need to write CSS at all,
you should just use the `#css` method in the component.

External JavaScript should go in `js/`, typically compatibility files like
`json2` and `sizzle` go there, or other libraries you are using that aren't
Opal libraries.
