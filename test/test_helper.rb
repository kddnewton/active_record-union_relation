# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'active_record/union'

require 'minitest/autorun'

require 'rails'
ActiveRecord::Tasks::DatabaseTasks.create_current

ActiveRecord::Base.establish_connection
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.boolean :published
    t.string :title
  end

  create_table :comments, force: true do |t|
    t.references :post
    t.text :body
  end

  create_table :tags, force: true do |t|
    t.string :name
  end
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class Post < ActiveRecord::Base
  has_many :comments
  accepts_nested_attributes_for :comments

  create!(published: false, title: 'foo not published')
  create!(
    published: true,
    title: 'foo published',
    comments_attributes: [
      { body: 'This is a comment' },
      { body: 'This is another comment' },
      { body: 'This is a comment with foo in it' }
    ]
  )
end

class Tag < ActiveRecord::Base
  create!([{ name: 'some' }, { name: 'tags' }, { name: 'foo' }])
end
