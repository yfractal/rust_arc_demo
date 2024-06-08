# frozen_string_literal: true

RSpec.describe RustArc do
  def memory_usage
    _, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)

    size
  end

  def insert_random(ruby_store)
    ruby_store.insert("key", Foo.new(rand, rand))
  end

  class Foo
    attr_reader :a, :b

    def initialize(a, b)
      @a, @b = a, b
    end
  end

  describe 'RubyStore' do
    it 'works' do
      store = RubyStore.new
      foo = Foo.new(1, 2)
      store.insert("key", foo)

      sleep 0.1
      GC.start

      expect(store.get("key").class).to eq Foo
      expect(store.get("key").a).to eq 1
      expect(store.get("key").b).to eq 2
    end

    it 'should not have memory issues' do
      store = RubyStore.new
      store.insert("key", Foo.new(1, 2))

      sleep 0.1
      GC.start

      expect(store.get("key").class).to eq Foo
    end

    it 'Ruby should collect unreferenced objects' do
      total = 10_000_000
      store = RubyStore.new

      count_objects_before = ObjectSpace.count_objects[:TOTAL]
      memory_before = memory_usage

      total.times { insert_random(store) }

      GC.start

      count_objects_after = ObjectSpace.count_objects[:TOTAL]
      memory_after = memory_usage

      expect(count_objects_after - count_objects_before).to be < total / 100
      expect(memory_after - memory_before).to be < 1500
    end
  end
end
