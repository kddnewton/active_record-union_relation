# frozen_string_literal: true

require "test_helper"

class ActiveRecord::UnionRelationTest < Minitest::Test
  def test_version
    refute_nil ::ActiveRecord::UnionRelation::VERSION
  end

  def test_empty_union
    assert_raises ActiveRecord::UnionRelation::NoConfiguredSubqueriesError do
      ActiveRecord.union(:id, :post_id, :matched) {}
    end
  end

  def test_bad_config_union
    assert_raises ActiveRecord::UnionRelation::MismatchedColumnsError do
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
end
