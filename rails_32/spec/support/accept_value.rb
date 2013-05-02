def accept_value(value)
  Matchers::AcceptValue.new value
end

def reject_value(value)
  Matchers::RejectValue.new value
end

module Matchers
  class ValueEvaluator
    def initialize value
      @value = value
    end

    def for attribute
      @attribute = attribute
      self
    end

    private

    def accepts_value? model
      @model = model
      model.send("#{attribute}=", value)
      model.valid?
      model.errors[attribute].empty?
    end

    def description_for value
      value.nil? ? "nil" : value.inspect
    end

    attr_reader :attribute, :model, :value
  end

  class AcceptValue < ValueEvaluator
    def matches? model
      accepts_value? model
    end

    def does_not_match? model
      !accepts_value? model
    end

    def failure_message_for_should
      "expected #{model.class.name} to accept value #{description_for value} for #{attribute}"
    end

    def failure_message_for_should_not
      "expected #{model.class.name} to reject value #{description_for value} for #{attribute}"
    end

    def description
      "accept #{description_for value} for #{attribute}"
    end
  end

  class RejectValue <  ValueEvaluator
    def matches? model
      !accepts_value? model
    end

    def does_not_match? model
      accepts_value? model
    end

    def failure_message_for_should
      "expected #{model.class.name} to reject value #{description_for value} for #{attribute}"
    end

    def failure_message_for_should_not
      "expected #{model.class.name} to reject value #{description value} for #{attribute}"
    end

    def description
      "reject #{description_for value} for #{attribute}"
    end
  end
end
