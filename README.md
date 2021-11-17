# ActiveRecord::UnionRelation

[![Build Status](https://github.com/kddnewton/active_record-union_relation/workflows/Main/badge.svg)](https://github.com/kddnewton/active_record-union_relation/actions)
[![Gem Version](https://img.shields.io/gem/v/active_record-union_relation.svg)](https://rubygems.org/gems/active_record-union_relation)

There are times when you want to use SQL's [UNION](https://www.w3schools.com/sql/sql_union.asp) operator to pull rows from multiple relations, but you still want to maintain the query-builder interface of ActiveRecord. This gem allows you to do that with minimal syntax.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-union_relation'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_record-union_relation

## Usage

Let's assume you're writing something like a search function, and you want to be able to return a polymorphic relation containing all of the search results. You could maintain a separate index table with links out to the entities or use a more advanced search engine. Or you could perform a `UNION` that searches each table.

`UNION` subrelations must all have the same number of columns, so first we define the name of the columns that the `UNION` will select, then we define the sources that will become those columns from each subrelation. It makes more sense looking at an example.

Let's assume we have the following structure with default table names:

```ruby
class Comment < ActiveRecord::Base
  belongs_to :post
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Tag < ActiveRecord::Base
end
```

Now, let's pull all of the records matching a specific term. For `Post`, we'll pull `published: true` records that have a `title` matching the term. For `Comment`, we'll pull the records that have a `body` matching the term. And finally, for `Tag`, we'll pull records that have a `name` matching the term.

```ruby
# Let's get a local variable that we'll use to reference within each of our
# subqueries. Presumably this would come from some kind of user input.
term = 'foo'

# First, we call ActiveRecord::union. The arguments are the names of the columns
# that will be aliased from each source relation. It also accepts a block that
# is used to configure the union's subqueries.
relation =
  ActiveRecord.union(:id, :post_id, :matched) do |union|
    # Okay, now we're going to pull the post records into a subquery. First,
    # we'll get a posts variable that contains the relation that we want to pull
    # just for this one table. That can include any kind of
    # joins/conditions/orders etc. that it needs to. In this case we'll need
    # published: true and a matching query.
    posts = Post.where(published: true).where('title LIKE ?', "%#{term}%")

    # Next, we'll add that posts relation as a subquery into the union. The
    # number of arguments here must directly align with the number of arguments
    # given to the overall union. In this case to line everything up, we'll
    # select id as the id column, nil as a placeholder since we don't need
    # anything for the post_id column, and title as the matched column.
    union.add posts, :id, nil, :title

    # Next we'll pull the comments relation that we want into its own variable,
    # and then add it into the overall union. We'll line up the id column to id,
    # the post_id column to post_id, and the body to matched. Since we're
    # explicitly pulling post_id, we'll actually be able to call .post on the
    # comment records that get pulled since we alias them back when we
    # instantiate the objects.
    comments = Comment.where('body LIKE ?', "%#{term}%")
    union.add comments, :id, :post_id, :body

    # Finally, we'll pull the tag records that we want and add them into the
    # overall union as well.
    tags = Tag.where('name LIKE ?', "%#{term}%")
    union.add tags, :id, nil, :name
  end

# Now we have a relation object that represents the UNION, and we can perform
# all of the mutations that we would normally perform on a relation.
relation.order(matched: :asc)

# This results in a polymorphic response that once we load the records has
# everything loaded and aliased properly, as in:
#
# [#<Tag:0x00 id: 3, name: "foo">,
#  #<Post:0x000 id: 2, title: "foo published">,
#  #<Comment:0x00 id: 3, post_id: 2, body: "This is a comment with foo in it">]
```

The query generated in the example above will look something like:

```sql
SELECT discriminator, id, post_id, matched
FROM (
  (SELECT 'Post' AS "discriminator", id AS "id", NULL AS "post_id", title AS "matched" FROM "posts" WHERE "posts"."published" = $1 AND (title LIKE '%foo%'))
  UNION
  (SELECT 'Comment' AS "discriminator", id AS "id", post_id AS "post_id", body AS "matched" FROM "comments" WHERE (body LIKE '%foo%'))
  UNION
  (SELECT 'Tag' AS "discriminator", id AS "id", NULL AS "post_id", name AS "matched" FROM "tags" WHERE (name LIKE '%foo%'))
) AS "union"
ORDER BY "matched" ASC 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To check types using `rbs`, you can run:

```sh
RBS_TEST_TARGET='ActiveRecord::UnionRelation::*' \
ruby -rrbs/test/setup \
  -Itest -Isig/active_record/union_relation.rbs \
  test/active_record/union_relation_test.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddnewton/active_record-union_relation.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
