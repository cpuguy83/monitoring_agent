module Agent
  class Handler
    include Celluloid
    attr_reader :output, :handle_class, :handle_method
    def initialize(output, handle_class=nil, handle_method=nil)
      @output = output
      @handle_class = handle_class
      @handle_method = handle_method
    end

    def call_local_handler
      if handle_class.respond_to(handle_method)
        handle_class.public_send(handle_method, output)
      end
      terminate
    end

    def call_global_handler
      # ...
      terminate
    end

  end
end
