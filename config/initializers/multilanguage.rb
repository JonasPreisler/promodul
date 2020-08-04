class ActiveRecord::Base
  def self.multilanguage(columns)
    columns.each do |column|
      self.base_class.class_eval do
        define_method column do
          attribute_value = self.attributes[column.to_s]
          MultiLanguage.value(attribute_value)
        end
        define_method "#{column}=" do |arg|
          self[column] = arg
        end
      end
    end
  end
end

class MultiLanguage
  def self.value(attribute_value)
    language_value = attribute_value['selected'] || attribute_value[I18n.locale.to_s] if attribute_value
    if (!language_value || language_value.empty?) && attribute_value
      I18n.available_locales.each do |loc|
        language_value = attribute_value[loc.to_s]
        break if language_value
      end
    end

    language_value.nil? ? attribute_value : language_value
  end

  def self.sql(column)
    ActiveRecord::Base.sanitize_sql_array(["json_language(#{column}, ?)", I18n.locale.to_s])
  end
end

# JSONValidator override
class JsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value = record.attributes[attribute.to_s]
    errors = ::JSON::Validator.fully_validate(schema(record), validatable_value(value), options.fetch(:options))

    return if errors.empty? && record.send(:"#{attribute}_invalid_json").blank?

    message(errors).each do |error|
      record.errors.add(attribute, error, value: value)
    end
  end
end

