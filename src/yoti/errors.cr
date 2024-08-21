module Yoti
  module Errors
    struct ErrorResponse
      include JSON::Serializable

      property code : String
      property message : String
      property errors : Array(Hash(String, String))
    end
  end
end
