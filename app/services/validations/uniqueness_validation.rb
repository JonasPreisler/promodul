module Validations
  module UniquenessValidation
    def record_uniq?(uniq_value, option = {})

      if self.send("#{option[:column]}_changed?")
        select = self.class.
            where.not(id: self.id).
            where(option[:column].to_sym => uniq_value)

        if option[:where]
          select.where(option[:where])
        end
        return !select.any?
      end
      return true
    end
  end
end