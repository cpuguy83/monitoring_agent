module Maxwell
  module Agent
    module Middleware
      class Chain
        include Enumerable
        attr_reader :entries

        def initialize
          @entries = []
          yield self if block_given?
        end

        def each(&block)
          entries.each(&block)
        end

        def add(klass, *args)
          new_entry = Entry.new(klass, *args)
          if count > 0
            add_at(count + 1, new_entry)
          else
            add_at(count, new_entry)
          end
        end

        def remove(entry)
          entries.delete_if {|e| e }
        end

        def insert_before(existing_klass, new_klass, *args)
          new_entry = Entry.new(new_klass, *args)
          i = get_index(existing_klass) || 0
          add_at(i, new_entry)
        end

        def insert_after(existing_klass, new_klass, *args)
          new_entry = Entry.new(new_klass, *args)
          i = get_index(existing_klass) || count - 1
          add_at(i + 1, new_entry)
        end

        def invoke(*args, &final_action)
          chain = retrieve.dup

          traverse_chain = -> do
            if chain.empty?
              final_action.call if final_action
            else
              chain.shift.call(*args, &traverse_chain)
            end
          end
          traverse_chain.call
        end

      private
        def add_at(index, new_entry)
          remove(new_entry) if exists?(new_entry)
          entries.insert(index, new_entry)
        end

        def get_index(klass)
          find_index {|entry| entry.klass == klass }
        end

        def exists?(entry)
          include?(entry)
        end

        def retrieve
          entries.map(&:build)
        end

        class Entry
          attr_reader :klass

          def initialize(klass, *args)
            @klass = klass
            @args = args
          end

          def build
            @klass.new(*@args)
          end

          def ==(other)
            self.klass == other.klass
          end
        end
      end
    end
  end
end
