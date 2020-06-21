module Validations
  module DateValidation
    def more_than?(date, option = {})
      return false unless date
      date >= (option[:compare_with] ? option[:compare_with].call : Date.new(1900, 1, 1))
    end

    def less_than?(date, option = {})
      return false unless date
      date <= (option[:compare_with] ? option[:compare_with].call : DateTime.now.to_date)
    end
  end
end