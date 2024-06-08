# frozen_string_literal: true

RSpec.describe RustArc do
  class Foo
    attr_reader :a, :b

    def initialize(a, b)
      @a, @b = a, b
    end
  end

  describe "RubyStore" do
    it 'works' do
      store = RubyStore.new
      foo = Foo.new(1, 2)
      store.insert("key", foo)

      GC.start

      expect(store.get("key").class).to eq Foo
      expect(store.get("key").a).to eq 1
      expect(store.get("key").b).to eq 2
    end
  end
end
