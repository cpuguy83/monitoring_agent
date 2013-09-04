module Agent
  class Worker
    class OptionError < StandardError; end

    include Celluloid


    def perform(work)
      set_work_options(work)
      work.output =  if work.arguments
                  perform_with_arguments
                else
                  perform_without_arguments
                end

    ensure
      clear_work_options
    end

  private

    def set_work_options(work)
      @work_class = work.work_class
      @work_args  = work.arguments
    end

    def clear_work_options
      @work_class = nil
      @work_args = nil
    end

    def perform_with_arguments
      work_class.perform(work_args)
    end

    def perform_without_arguments
      work_class.perform
    end
  end
end
