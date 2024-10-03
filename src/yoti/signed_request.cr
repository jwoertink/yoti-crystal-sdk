require "http/headers"

module Yoti
  class SignedRequest
    protected class_getter private_key : String do
      File.read(Yoti.settings.key_file_path)
    end

    @path : String

    def initialize(@method : String, endpoint : String, @payload : Yoti::DocScan::SessionSpecification? = nil, nonce : UUID? = UUID.random, timestamp : Int64? = Time.utc.to_unix)
      @path = "/#{endpoint}?sdkId=#{Yoti.settings.client_sdk_id}&nonce=#{nonce}&timestamp=#{timestamp}"
    end

    def self.post(endpoint : String, payload : Yoti::DocScan::SessionSpecification, &block : HTTP::Client::Response -> _)
      self.new("POST", endpoint, payload).exec(&block)
    end

    def self.get(endpoint : String, &block : HTTP::Client::Response -> _)
      self.new("GET", endpoint).exec(&block)
    end

    def exec(&)
      HTTP::Client.exec(@method, url_for(@path), headers, @payload.try(&.to_json)) do |response|
        yield response
      end
    end

    private def url_for(path : String) : String
      String.build do |io|
        io << Yoti.doc_scan_api_endpoint
        io << path
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

    # https://developers.yoti.com/identity-verification-api#authentication
    private def message_signature : String
      ssl = Yoti::SSL.new(self.class.private_key)
      message = if data = @payload
                  [@method, @path, base64_payload(data)].join('&')
                else
                  [@method, @path].join('&')
                end
      ssl.sign(message)
    end

    private def base64_payload(data) : String
      Base64.strict_encode(data.to_json)
    end
  end
end
