module Maxwell
  module Agent
    module RedisObjects
      class SortedSet
        include RedisObjects
        include Celluloid
        attr_reader :name

        def initialize(name)
          @name = name
        end

        def add(score, object)
          redis { |redis| redis.zadd name, score, object.to_json }
        end

        def count
          redis {|redis| redis.zcard name }
        end

        def all
          redis {|redis| redis.zrange name, 0, -1 }
        end

        def first
          redis { |redis| redis.zrange(name, 0, 0)[0] }
        end

        def remove(item)
          redis { |redis| redis.zrem name, item.to_json }
        end

      end
    end
  end
end
