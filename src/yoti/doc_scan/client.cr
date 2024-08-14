module Yoti
  module DocScan
    class Client
      struct Session
        include JSON::Serializable

        property client_session_token_ttl : Int32
        property session_id : UUID
        property client_session_token : UUID
      end

      def create_session(payload) : Session
        endpoint = Yoti.doc_scan_api_endpoint + "/sessions?sdkId=#{Yoti.settings.client_sdk_id}"
        Yoti::SignedRequest.new("POST", endpoint, payload).exec do |response|
          Session.from_json(response.body)
        end
      end
    end
  end
end
