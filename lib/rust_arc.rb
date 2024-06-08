# frozen_string_literal: true

require_relative "rust_arc/version"
require 'rutie'

module RustArc
  Rutie.new(:ruby_example).init 'Init_ruby_example', __dir__
end
