module General
  class RespondResultService
    def call(response_data = {})
      result = {
        status_code: response_data[:status_code],
        success?: response_data[:success?],
        content: {}
      }

      if result[:success?]
        result[:content][:data] = response_data[:data] ||= {}
      else
        result[:content][:errors] = response_data[:errors] ||= []
      end

      OpenStruct.new(result)
    end
  end
end
