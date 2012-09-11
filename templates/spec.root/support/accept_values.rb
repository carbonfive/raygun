# Based on https://github.com/bogdan/accept_values_for

def accept_values(attribute, *values)
  AcceptValues.new(attribute, *values)
end

class AcceptValues  #:nodoc:

  def initialize(attribute, *values)
    @attribute = attribute
    @values = values
  end

  def matches?(model)
    @model = model
    #return false unless model.is_a?(ActiveRecord::Base)
    @values.each do |value|
      model.send("#{@attribute}=", value)
      model.valid?
      if model.errors[@attribute].present?
        @failed_value = value
        return false
      end
    end
    true
  end

  def does_not_match?(model)
    @model = model
    #return false unless model.is_a?(ActiveRecord::Base)
    @values.each do |value|
      model.send("#{@attribute}=", value)
      model.valid?
      unless model.errors[@attribute].present?
        @failed_value = value
        return false
      end
    end
    true
  end

  def failure_message_for_should
    result = "expected #{@model.class.name} to accept value #{@failed_value.inspect} for #{@attribute.inspect}\n"
    result += 'Errors: ' + @model.errors[@attribute].join(', ') if @model.respond_to?(:errors)
    result
  end

  def failure_message_for_should_not
    "expected #{@model.class.name} to reject value #{@failed_value.inspect} for #{@attribute.inspect} attribute"
  end

  def description
    "accept values #{@values.map(&:inspect).join(', ')} for #{@attribute.inspect}"
  end
end
