# frozen_string_literal: true

require_relative "rust_arc/version"
require 'rutie'

module RustArc
  Rutie.new(:ruby_example).init 'Init_ruby_example', __dir__
end

class RubyStore
  def insert(key, val)
    @val = val
    insert_inner(key, val)
  end
end
