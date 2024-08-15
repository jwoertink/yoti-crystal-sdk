module Yoti
  module DocScan
    class Client
      struct Session
        include JSON::Serializable

        property client_session_token_ttl : Int32
        property session_id : UUID
        property client_session_token : UUID
      end

      def create_session(payload : Yoti::DocScan::SessionSpecification) : Session
        endpoint = url_for("sessions")
        Yoti::SignedRequest.post(endpoint, payload) do |response|
          Session.from_json(response.body)
        end
      end

      # NOTE: I'm returning JSON::Any here because mapping this output would be
      # super gnarly https://developers.yoti.com/identity-verification/results#result-of-the-session
      def get_session(session_id : UUID) : JSON::Any
        endpoint = url_for("sessions/#{session_id}")
        Yoti::SignedRequest.get(endpoint) do |response|
          JSON.parse(response.body)
        end
      end

      def get_media_content(session_id : UUID, media_id : String) : Yoti::Media
        endpoint = url_for("sessions/#{session_id}/media/#{media_id}/content")
        Yoti::SignedRequest.get(endpoint) do |response|
          Yoti::Media.new(response.body, response.headers["Content-Type"])
        end
      end

      private def url_for(path : String) : String
        String.build do |io|
          io << Yoti.doc_scan_api_endpoint
          io << "/#{path}"
          io << "?sdkId=#{Yoti.settings.client_sdk_id}"
        end
      end
    end
  end
end
