module Maxwell
  module Agent
    module RedisObjects
      class Set
        include RedisObjects
        attr_reader :name

        def initialize(name)
          @name = name
        end

        def add(object)
          redis {|redis| redis.sadd name, object.to_json }
        end

        def remove(object)
          redis {|redis| redis.srem name, object.to_json }
        end

        def all
          redis {|redis| redis.smembers name}
        end

        def count
          redis {|redis| redis.scard name }
        end

        def exists?(object)
          if redis {|redis| redis.sismember name, object }
            true
          else
            false
          end
        end

        def find_by(key, value)
          all.reject {|host| host if host.key != value }
        end
      end
    end
  end
end
