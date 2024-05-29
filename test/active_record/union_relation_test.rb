# frozen_string_literal: true

require "test_helper"

module ActiveRecord
  class UnionRelationTest < Minitest::Test
    def test_version
      refute_nil UnionRelation::VERSION
    end

    def test_empty_union
      assert_raises UnionRelation::NoConfiguredSubqueriesError do
        ActiveRecord.union(:id, :post_id, :matched) {}
      end
    end

    def test_bad_config_union
      assert_raises UnionRelation::MismatchedColumnsError do
        ActiveRecord.union(:id) { |union| union.add Post.all, :id, :title }
      end
    end

    def test_good_union
      term = "foo"
      relation =
        ActiveRecord.union(:id, :post_id, :matched) do |union|
          posts = Post.where(published: true).where("title LIKE ?", "%#{term}%")
          comments = Comment.where("body LIKE ?", "%#{term}%")
          tags = Tag.where("name LIKE ?", "%#{term}%")

          union.add posts, :id, nil, :title
          union.add comments, :id, :post_id, :body
          union.add tags, :id, nil, :name
        end

      unioned = relation.order(matched: :asc).group_by(&:class)
      assert_equal 3, unioned.length

      assert_kind_of Post, unioned[Comment][0].post
    end

    def test_counts
      relation = ActiveRecord.union(:id, :post_id) do |union|
        posts = Post.where(published: true)
        comments = Comment.where("body LIKE ?", "%foo%")

        union.add posts, :id, nil
        union.add comments, :id, :post_id
      end

      assert_equal 2, relation.count
    end

    # When using joined queries it's often required to append the table/scope name
    # before the column name. This is to disambiguate the column name.
    # ActiveRecord attributes should not contain the scope/table part of this
    # name.
    def test_scoped_column_union
      relation =
        ActiveRecord.union(:id, :post_id, :body, :title) do |union|
          comments = Comment.joins(:post).where(posts: { published: true })
          posts = Post.none

          union.add comments,
                    "comments.id",
                    "comments.post_id",
                    "comments.body",
                    :title

          union.add posts, nil, "posts.id", nil, :title
        end

      items = relation.order(title: :asc)
      assert_kind_of Post, items.first.post
    end
  end
end
