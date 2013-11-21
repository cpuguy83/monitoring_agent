module Agent
  class Work
    include Comparable
    attr_reader :attributes
    def self.instance_attrs
      [:name, :work_class, :arguments, :perform_at, :frequency,
        :last_run, :output, :other_attributes]
    end

    def to_json
      hash = {}
      self.class.instance_attrs.each do |attr|
        hash[attr] = self.send(attr)
      end

      hash.to_json
    end

    def initialize(attrs={})
      @attributes = {}

      attrs.each do |key, value|
        public_send("#{key}=", value) if self.class.instance_attrs.include? key
      end
      yield self if block_given?
      self.last_run ||= Time.new(0)
      self.frequency ||= 30.minutes
    end

    instance_attrs.each do |attr|
      define_method attr do |value=nil|
        @attributes[attr] = value if value
        @attributes[attr]
      end

      define_method "#{attr}=" do |value|
        @attributes[attr] = value
      end
    end

    def ==(other)
      other.class == self.class &&
        other.attributes.except(:id) == self.attributes.except(:id)
    end

    def work_now?
      return perform_at_less_than_now? if perform_at
      return stale? if frequency
      true
    end

    def perform
      return perform_with_arguments if arguments
      perform_without_arguments
    end

    def expected_next_run
      return perform_at + last_run.to_i if perform_at
      return last_run + frequency if last_run && frequency
      Time.new(0)
    end

    def generate_rank
      expected_next_run.to_i
    end

  private

    def perform_with_arguments
      work_class.perform(arguments)
    end

    def perform_without_arguments
      work_class.perform
    end

    def time_since_last_run
      Time.now - last_run
    end

    def perform_at_less_than_now?
      return perform_at.find {|at| at <= Time.now } if perform_at.respond_to? :each
      perform_at <= Time.now
    end

    def stale?
      time_since_last_run >= frequency
    end
  end
end
