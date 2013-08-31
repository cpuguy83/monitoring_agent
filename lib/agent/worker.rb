module Agent
  class Worker
    class OptionError < StandardError; end

    include Celluloid

    attr_reader :work_class, :work_method, :work_arguments

    def perform(opts={})
      set_work_options(opts)

      output =  if work_arguments
                  perform_with_arguments
                else
                  perform_without_arguments
                end
      clear_worker_options
    end

  private

    def set_work_options(opts={})
      raise OptionError, "Missing work_class option" unless opts[:work_class]

      @work_class = opts[:work_class]
      @work_arguments = opts[:work_arguments]
    end

    def clear_work_options
      @work_class = nil
      @work_arguments = nil
    end

    def perform_with_arguments
      work_class.perform(work_arguments)
    end

    def perform_without_arguments
      work_class.perform
    end
  end
end
