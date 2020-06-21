module Sorcery
  module Adapters
    class ActiveRecordAdapter

      class << self
        def find_by_credentials(credentials)
          relation = nil

          @klass.sorcery_config.username_attribute_names.each do |attribute|
            if @klass.sorcery_config.downcase_username_before_authenticating
              condition = @klass.arel_table[attribute].lower.eq(@klass.arel_table.lower(credentials[0]))
            else
              condition = @klass.arel_table[attribute].eq(credentials[0])
            end

            relation = if relation.nil?
                         condition
                       else
                         relation.or(condition)
                       end
          end

          @klass.where(relation).where(active: true).first
        end
      end
    end
  end
end