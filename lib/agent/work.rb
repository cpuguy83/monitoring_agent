require 'securerandom'

module Agent
  class Work
    include Comparable
    attr_reader :attributes, :id
    def self.instance_attrs
      [:name, :work_class, :arguments,:perform_at, :frequency,
        :last_run, :output]
    end
    def initialize(attrs={})
      @attributes = {}

      attrs.each do |key, value|
        if self.class.instance_attrs.include? key
          public_send("#{key}=", value)
        end
      end
      self.last_run ||= Time.new(0)
      self.frequency ||= 30.minutes

      @id = SecureRandom.uuid

    end

    def save
      Celluloid::Actor[:work_schedule].add(self)
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
      if perform_at
        perform_at_less_than_now?
      elsif frequency
        stale?
      else
        true
      end
    end

    def perform
      if arguments
        perform_with_arguments
      else
        perform_without_arguments
      end

      self.perform_at = nil
    end

    def <=>(other)
      if use_perform_at_for_comparison? && other.use_perform_at_for_comparison?
        perform_at <=> other.perform_at
      elsif use_perform_at_for_comparison? &&
        !other.use_perform_at_for_comparison?
          perform_at <=> other.expected_next_run
      elsif !use_perform_at_for_comparison? &&
        other.use_perform_at_for_comparison?
          expected_next_run <=> other.perform_at
      else
        expected_next_run <=> other.expected_next_run
      end
    end

    def expected_next_run
      if last_run && frequency
        last_run + frequency
      else
        Time.new(0)
      end
    end

  protected

    def use_perform_at_for_comparison?
      perform_at <= expected_next_run if perform_at
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
      if perform_at.respond_to? :each
        perform_at.find { |at| at <= Time.now }
      else
        perform_at <= Time.now
      end
    end

    def stale?
      time_since_last_run >= frequency
    end
  end
end
