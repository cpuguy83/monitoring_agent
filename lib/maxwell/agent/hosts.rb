module Maxwell
  module Agent
    class Hosts < RedisObjects::Set

      def initialize
        @name = :hosts
      end

    end
  end
end
