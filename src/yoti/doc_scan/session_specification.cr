module Yoti
  module DocScan
    class SessionSpecification
      def self.build(&) : self
        inst = self.new
        yield inst
        inst.close
        inst
      end

      delegate to_s, to: @io

      getter builder : JSON::Builder
      getter? document_closed : Bool = false

      def initialize
        @io = IO::Memory.new
        @builder = JSON::Builder.new(@io)
        @builder.indent = "  "
        @builder.start_document
        @builder.start_object
      end

      def close : Nil
        @document_closed = true
        @builder.end_object
        @builder.end_document
      end

      def to_json : String
        if document_closed?
          @io.to_s
        else
          raise "Called #to_json on SessionSpecification before the JSON document was closed. Be sure to call #close first."
        end
      end

      def with_client_session_token_ttl(ttl_seconds : Int32) : self
        @builder.field("client_session_token_ttl", ttl_seconds)
        self
      end

      # NOTE: If `client_session_token_ttl` is called, this field can't be used
      def with_session_deadline(time : Time) : self
        @builder.field("session_deadline", time.to_rfc3339)
        self
      end

      def with_resources_ttl(ttl_seconds : Int32) : self
        @builder.field("resources_ttl", ttl_seconds)
        self
      end

      def with_user_tracking_id(user_id : String) : self
        @builder.field("user_tracking_id", user_id)
        self
      end

      def with_notifications(&) : self
        @builder.field("notifications") do
          @builder.object do
            yield
          end
        end
        self
      end

      def with_requested_checks(&) : self
        @builder.field("requested_checks") do
          @builder.array do
            yield
          end
        end
        self
      end

      def with_requested_tasks(&) : self
        @builder.field("requested_tasks") do
          @builder.array do
            yield
          end
        end
        self
      end

      def with_sdk_config(&) : self
        @builder.field("sdk_config") do
          @builder.object do
            yield
          end
        end
        self
      end
    end
  end
end
