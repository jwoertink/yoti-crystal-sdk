module Yoti
  module DocScan
    class SessionSpecification
      class RequestedCheck
        def self.build(builder : JSON::Builder, &) : self
          inst = self.new(builder)
          builder.object do
            yield inst
          end
          inst
        end

        def initialize(@builder : JSON::Builder)
        end

        def with_type(type : String) : self
          @builder.field("type", type)
          self
        end

        def with_config(config_options : NamedTuple) : self
          @builder.field("config") do
            @builder.object do
              config_options.each do |key, value|
                @builder.field(key.to_s, value)
              end
            end
          end
          self
        end

        def with_config : self
          @builder.field("config") do
            @builder.object do
            end
          end
          self
        end
      end
    end
  end
end
