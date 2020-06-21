module ErrorsFormat

  def fill_custom_errors(object, field, code_name, message)
    object_errors = object.errors

    code = read_error_codes_from_file[code_name.to_s]

    default_code = 0

    code = default_code unless code_name && code

    object_errors << {
        message: message,
        code: code,
        field: field,
    }
  end

  private

  def fill_errors(object)
    details_hash  = object.errors.details

    error_types  = []
    error_fields = []

    error_messages = slice_full_messages(object.errors.full_messages, details_hash)

    details_hash.each do  |key, value|
      error_fields << key
      error_types  << value
    end

    types_and_messages = zip_types_and_messages(error_types, error_messages, details_hash.length)

    merge_messages_and_fields(types_and_messages, error_fields)
  end

  def read_error_codes_from_file
    file = File.read "lib/error_codes.json"
    JSON.parse(file)
  end

  def slice_full_messages(full_messages, details_hash)

    error_messages = []
    details_hash.each do |_, value|
      error_messages << full_messages.slice!(0, value.length)
    end

    error_messages
  end

  def zip_types_and_messages(error_types, error_messages, details_hash_length)
    types_and_messages = []
    (0...details_hash_length).each do | i |
      types_and_messages[i] = error_types[i].zip(error_messages[i])
    end

    types_and_messages
  end

  def merge_messages_and_fields(types_and_messages, error_fields)
    errors = []
    custom_error_codes = read_error_codes_from_file
    default_code = 5

    types_and_messages.each_with_index do |type_and_message, index|
      type_and_message.each do |element|
        if element[0][:error].to_s == nil || custom_error_codes[element[0][:error].to_s] == nil
          code = default_code
        else
          code = custom_error_codes[element[0][:error].to_s]
        end
        errors << {
            message:  element[1],
            code:     code,
            field:    error_fields[index],
        }
      end
    end

    errors
  end
end

