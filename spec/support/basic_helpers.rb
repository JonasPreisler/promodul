# DHP-50
module BasicHelpers
  def parse_json_response(body)
    JSON.parse(body, symbolize_names: true)
  end
end
