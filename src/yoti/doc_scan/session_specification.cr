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

      def initialize
        @io = IO::Memory.new
        @builder = JSON::Builder.new(@io)
        @builder.indent = " "
        @builder.start_document
        @builder.start_object
      end

      def close : Nil
        @builder.end_object
        @builder.end_document
      end

      def with_client_session_token_ttl(ttl_seconds : Int32) : self
        @builder.field("client_session_token_ttl", ttl_seconds)
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

      def with_requested_check(&) : self
        yield
        self
      end

      def with_requested_task(&) : self
        yield
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
