# Harvester

Parse complex HTML structures using powerful DSL.

## Synopsis

```
require 'pp'
require 'harvester'

article = <<-EOF
<html>
<head><title>Test article title</title></head>
<body>
  <h1>Test article header</h1>
  <article>
    <section>
      <h2>Header 1</h2>
      <p>Paragraph 1</p>
    </section>
    <section>
      <h2>Header 2</h2>
      <p>Paragraph 2</p>
    </section>
    <div id="author-block">
      <span class="name">John Doe</span>
      <a href="/authors/1">profile</a>
      <a href="http://twitter.com/johndoe">twitter</a>
    </div>
  </article>
</body>
EOF

harvester = Harvester.new do |h|
  h.element :title, :selectors => "title"
  h.element :header, :selectors => "h1"
  h.children :sections, :selectors => "article > section" do |s|
    s.element :header, :selectors => "h2"
    s.element :body, :selectors => "p"
  end
  h.child :author, :selectors => "div#author-block" do |a|
    a.element :name, :selectors => "span.name"
    a.link :profile, :selectors => "a", :link_regex => %r{^/authors/\d+$}
    a.link :twitter, :selectors => "a", :link_regex => %r{twitter.com}
  end
end


pp harvester.parse(article)
# {:title=>"Test article title",
#  :header=>"Test article header",
#  :sections=>
#   [{:header=>"Header 1", :body=>"Paragraph 1"},
#    {:header=>"Header 2", :body=>"Paragraph 2"}],
#  :author=>
#   {:name=>"John Doe",
#    :profile=>"/authors/1",
#    :twitter=>"http://twitter.com/johndoe"}}
```

See other examples in `examples` folder.

## Available parsers

Almost all parsers accept `selector` or `selectors` option which specifies CSS or XPath selector they will use. XPath syntax is used when selectors start with '/', '//' or './'. CSS in all the other cases.

You can pass an array of selectors.

## Primitives

### `element`

Extracts text for elements matching given selector:

```
harvester = Harvester.new do |h|
  h.element :title, :selector => "h1"
end

harvester.parse("<h1>Hello</h1>")
# => {:title => "Hello"}
```

### `link`

Finds a link matching given selector and href regex. Its href is returned.

```
harvester = Harvester.new do |h|
  h.link :github, :link_regex => /github/
end

harvester.parse("<a href='/'>Home</a> <a href='https://github.com'>Github</a>")
# => {:github => 'https://github.com'}
```

### `links`

Links parser is the same thing, only it returns all matching links instead of the first one.

### `link_with_uid`

This is a tricky one. Returns a hash containing two keys: `:url` for link href and `:uid` for link unique id. `uid` is used to generate a string from url query values. For example, if `url` is `/x.php?id=1&sid=abcde&player=2`, and you use `['id', 'player']` for uid generation, your resulting uid is `"1_2"` (that's 1 and 2 joined by underscores). Ordering doesn't matter. Also note, that your url is then normalized using the same params, so it becomes `/x.php?id=1&player=2`


```
harvester = Harvester.new do |h|
  h.link_with_uid :hero_code, :link_regex => /x.php/, :uid_keep_params => ["id", "player"]
end
harvester.parse("<a href='/x.php?id=1&sid=abcde&player=2'>player</a>")
# => {:hero_code => {:url => '/x.php?id=1&player=2', :uid => "1_2"}}
```

### `links_with_uid`

Same as the previous one, but returns an array of links.

### `date`

Extracts and parses whatever looks as date. You must specify a regex for text matching (sometimes you can get away with `/(.*)/`).

```
harvester = Harvester.new do |h|
  h.date :published_at, :selector => "span.time", :regex => /^Published at: (.*)$/
end

harvester.parse("<span class='time'>Published at: 01/25/2012 05:00</span>")
# => {:published_at => 2012-01-25 05:00:00 UTC }
```

## Relative parsers

### `child`

Runs a parser inside of your parser, creating nested structure.

```
harvester = Harvester.new do |h|
  h.child :author, :selector => "div#author" do |a|
    a.element :name, :selector => "span.name"
  end
end
harvester.parse("<div id='author'><span class='name'>John Doe</span></div>")
# => {:author => {:name => "John Doe"}}
```

### `children`

Same as `child`, but returns an array of hashes.

### `prev_sibling`, `next_sibling`, `parent`

Sometimes you need to move slightly around the DOM tree. This is what these three parsers are for.

Attention: these parsers do not nest, but they merge directly into the parent parser.

```
harvester = Harvester.new do |h|
  h.child :post, :selector => "div.post" do |p|
    p.prev_sibling :selector => "div.info" do |i|
      i.element :title, :selector => "h1"
    end
  end
end
harvester.parse("<div class='info'><h1>Hello</h1></div><div class='post'></div>")
# => {:post => {:title => "Hello"}}
```

### `text`

Extracts value from current node. Rarely required.

```
harvester = Harvester.new do |h|
  h.child :post, :selector => "div.post" do |p|
    p.text :body
  end
end

harvester.parse("<div class='post'><b>Hello</b> world</div>")
# => {:post => {:body => "Hello world"}}
```


## Dependencies

* Ruby (currently 1.9)
* Nokogiri
* Addressable
* Chronic18n if you want to use date parsing
    * Use [my fork](https://github.com/markiz/chronic18n) if you desire to use russian locale for dates

## Feedback

Use github issues or contact me directly by mail (markizko+harvester@gmail.com)

## License

Harvester is released into public domain (http://unlicense.org/UNLICENSE)
