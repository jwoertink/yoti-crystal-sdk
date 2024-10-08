module Yoti
  module DocScan
    class SessionSpecification
      class SdkConfig
        def self.build(builder : JSON::Builder, &) : self
          inst = self.new(builder)
          yield inst
          inst
        end

        def initialize(@builder : JSON::Builder)
        end

        def with_allowed_capture_methods(capture_method : String) : self
          @builder.field("allowed_capture_methods", capture_method)
          self
        end

        def with_primary_colour(hex_color_value : String) : self
          @builder.field("primary_colour", hex_color_value)
          self
        end

        def with_secondary_colour(hex_color_value : String) : self
          @builder.field("secondary_colour", hex_color_value)
          self
        end

        def with_font_colour(hex_color_value : String) : self
          @builder.field("font_colour", hex_color_value)
          self
        end

        def with_preset_issuing_country(iso3_country : String) : self
          @builder.field("preset_issuing_country", iso3_country)
          self
        end

        def with_success_url(success_url : String) : self
          @builder.field("success_url", success_url)
          self
        end

        def with_error_url(error_url : String) : self
          @builder.field("error_url", error_url)
          self
        end

        def with_locale(locale : String) : self
          @builder.field("locale", locale)
          self
        end

        def with_allow_handoff : self
          @builder.field("allow_handoff", true)
          self
        end

        def with_privacy_policy_url(url : String) : self
          @builder.field("privacy_policy_url", url)
          self
        end
      end
    end
  end
end
