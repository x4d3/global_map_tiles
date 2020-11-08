class HaveValuesWithinMatcher
  def initialize(percent)
    @percent = percent
  end

  def percent_of(expected_values)
    @expected_values = expected_values
    self
  end

  def matches?(actual_values)
    @actual_values = actual_values
    raise needs_expected unless defined? @expected_values

    return false unless @actual_values.length === @expected_values.length

    @actual_values.zip(@expected_values) do |actual, expected|
      if expected == 0
        return false if actual != 0
      elsif ((actual - expected) / expected).abs > (@percent / 100)
        return false
      end
    end
    true
  end

  def failure_message
    "expected #{@actual_values} to be within #{@percent}% of #{@expected_values}"
  end

  private

  def needs_expected
    ArgumentError.new "You must set an expected value using #of: has_values_within(#{@delta}).percent_of(expected_values)"
  end
end
