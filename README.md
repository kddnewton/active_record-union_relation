# ActiveRecord::Union

[![Build Status](https://github.com/kddeisz/active_record-union/workflows/Main/badge.svg)](https://github.com/kddeisz/active_record-union/actions)

There are times when you want to use SQL's [UNION](https://www.w3schools.com/sql/sql_union.asp) operator to pull rows from multiple relations, but you still want to maintain the query-builder interface of ActiveRecord. This gem allows you to do that with minimal syntax.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-union'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_record-union

## Usage

Let's assume you're writing something like a search function, and you want to be able to return a polymorphic relation containing all of the search results. You could maintain a separate index table with links out to the entities or use a more advanced search engine. Or you could perform a `UNION` that searches each table.

`UNION` subrelations must all have the same number of columns, so first we define the name of the columns that the `UNION` will select, then we define the sources that will become those columns from each subrelation. It makes most sense looking at an example:

```ruby
Post.union(:id, :post_id, :matched) do |union|
  posts = Post.where(published: true).where('title LIKE ?', "%#{term}%")
  union.add posts, :id, nil, :title

  comments = Comment.where('body LIKE ?', "%#{term}%")
  union.add comments, :id, :post_id, :body

  tags = Tag.where('name LIKE ?', "%#{term}%")
  union.add tags, :id, nil, :name
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddeisz/active_record-union.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
