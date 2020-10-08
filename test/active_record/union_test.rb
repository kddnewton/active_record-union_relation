# frozen_string_literal: true

require 'test_helper'

class ActiveRecord::UnionTest < Minitest::Test
  def test_version
    refute_nil ::ActiveRecord::Union::VERSION
  end
end
