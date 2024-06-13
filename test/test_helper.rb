# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "active_record/union_relation"
require "minitest/autorun"
require "rails"

ENV["DATABASE_URL"] ||= "sqlite3::memory:"
ActiveRecord::Tasks::DatabaseTasks.create_current

ActiveRecord::Base.establish_connection
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :tags, force: true do |t|
    t.string :name
  end

  create_table :posts, force: true do |t|
    t.boolean :published
    t.string :title
  end

  create_table :comments, force: true do |t|
    t.references :post
    t.text :body
  end

  create_table :links, force: true do |t|
    t.string :type
    t.string :url
  end
end

class Tag < ActiveRecord::Base
end

class Post < ActiveRecord::Base
  has_many :comments
  accepts_nested_attributes_for :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class Link < ActiveRecord::Base
end

class ImageLink < Link
end

class VideoLink < Link
end

class AudioLink < Link
end

ActiveRecord::Base.transaction do
  Tag.create!([{ name: "some" }, { name: "tags" }, { name: "foo" }])

  Post.create!(
    [
      { published: false, title: "foo not published" },
      {
        published: true,
        title: "foo published",
        comments_attributes: [
          { body: "This is a comment" },
          { body: "This is another comment" },
          { body: "This is a comment with foo in it" }
        ]
      }
    ]
  )

  Link.create!(
    [
      { type: "ImageLink", url: "http://example.com/some-image" },
      { type: "VideoLink", url: "http://example.com/some-video" },
      { type: "AudioLink", url: "http://example.com/some-audio1" },
      { type: "AudioLink", url: "http://example.com/some-audio2" }
    ]
  )
end
