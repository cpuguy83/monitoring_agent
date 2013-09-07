module Agent
  class Scheduler
    include Celluloid
    include Clockwork

    def initialize
      super
      async.start
    class Configuration
      def initialize
        load_config
      end

      def work(name=nil, &block)
        work = Agent::Work.new
        work.name = name if name
        work.instance_eval(&block)

        work.save

        work
      end
      alias_method :check, :work


    private
      def load_config
        file = File.expand_path("../../../config/schedule.rb", __FILE__)
        eval(File.open(file).read) if File.exists? file
      end
    end

    def start
      load_config
      configure_clockwork
      run
    end

    def configure_clockwork
      configure do |c|
        c[:logger] = ::Logger.new('/tmp/test.log')
      end
    end
  private
    def load_config
      Configuration.new
    end

  end
end
