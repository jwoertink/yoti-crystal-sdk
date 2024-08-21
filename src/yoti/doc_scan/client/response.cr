module Yoti
  module DocScan
    class Client
      record Response, body : String, status : HTTP::Status do
        def error : Yoti::Errors::ErrorResponse?
          if status.value >= 400
            Yoti::Errors::ErrorResponse.from_json(body)
          end
        end
      end
    end
  end
end
