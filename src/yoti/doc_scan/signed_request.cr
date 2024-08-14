require "http/headers"

module Yoti
  class SignedRequest
    protected class_getter private_key : String do
      File.read(Yoti.settings.key_file_path)
    end

    def initialize(@method : String, @url : String, @payload)
    end

    def exec(&)
      HTTP::Client.exec(@method, @url, headers, body) do |response|
        yield response
      end
    end

    private def headers : HTTP::Headers
      HTTP::Headers{
        "X-Yoti-Auth-Digest" => message_signature,
        "X-Yoti-SDK"         => Yoti.settings.sdk_identifier,
        "X-Yoti-SDK-Version" => "#{Yoti.settings.sdk_identifier}-#{Yoti::VERSION}",
        "Accept"             => "application/json",
      }
    end

    private def message_signature : String
      ssl = Yoti::SSL.new(self.class.private_key)
      ssl.sign([@method, @path, base64_payload].join('&'))
    end

    private def base64_payload : String
      Base64.encode(@payload.to_json)
    end
  end
end
