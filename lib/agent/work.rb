module Agent
  class Work
    attr_reader :attributes
    def self.instance_attrs
      [:work_class, :arguments, :perform_at, :frequency, :last_run, :output]
    end
    def initialize(attrs={})
      @attributes = {}

      attrs.each do |key, value|
        if self.class.instance_attrs.include? key
          public_send("#{key}=", value)
        end
      end

      perform_at ||= Time.new(0)
    end

    instance_attrs.each do |attr|
      define_method attr do
        @attributes[attr]
      end

      define_method "#{attr}=" do |value|
        @attributes[attr] = value
      end
    end

    def ==(other)
      other.class == self.class &&
        other.attributes == self.attributes
    end

    def work_now?
      if perform_at && frequency
        perform_at_less_than_now? && stale?
      elsif peform_at && !frequency
        perform_at_less_than_now?
      elsif frequency && !perform_at
        stale?
      else
        true
      end
    end
  private
    def time_since_last_run
      Time.now - last_run
    end

    def perform_at_less_than_now?
      if perform_at.respond_to? :each
        perform_at.find { |at| at < Time.now }
      else
        perform_at < Time.now
      end
    end

    def stale?
      time_since_last_run >= frequency
    end
  end
end
