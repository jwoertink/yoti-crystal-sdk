module Yoti
  module DocScan
    class SessionSpecification
      class Notifications
        def self.build(builder : JSON::Builder, &) : self
          inst = self.new(builder)
          yield inst
          inst
        end

        def initialize(@builder : JSON::Builder)
        end

        def with_endpoint(url : String) : self
          @builder.field("endpoint", url)
          self
        end

        def with_topics(topics : Array(String)) : self
          @builder.field("topics") do
            @builder.array do
              topics.each do |topic|
                @builder.string(topic)
              end
            end
          end

          self
        end

        def with_auth_token(basic_auth_string : String) : self
          @builder.field("auth_token", basic_auth_string)
          self
        end

        def with_auth_type_basic : self
          @builder.field("auth_type", "BASIC")
          self
        end

        def with_auth_type_bearer : self
          @builder.field("auth_type", "BEARER")
          self
        end
      end
    end
  end
end
