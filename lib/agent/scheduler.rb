module Agent
  class Scheduler
    include Celluloid
    include Clockwork

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
      file = File.expand_path("../../../config/schedule.rb", __FILE__)
      eval(File.open(file).read) if File.exists? file
    end
  end
end
