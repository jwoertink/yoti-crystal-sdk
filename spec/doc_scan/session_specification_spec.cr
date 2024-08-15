require "../spec_helper"

describe Yoti::DocScan::SessionSpecification do
  it "builds the appropriate JSON" do
    sepcs = Yoti::DocScan::SessionSpecification.build do |specs_builder|
      specs_builder.with_client_session_token_ttl(600)
        .with_resources_ttl(604800)
        .with_user_tracking_id("<YOUR_USER_ID>")
        .with_notifications {
          Yoti::DocScan::SessionSpecification::Notifications.build(specs_builder.builder) do |notification_builder|
            notification_builder.with_endpoint("https://yourdomain.example/idverify/updates")
              .with_topics(["resource_update", "task_completion", "check_completion", "session_completion"])
              .with_auth_token("username:password")
          end
        }
        .with_requested_checks {
          Yoti::DocScan::SessionSpecification::RequestedCheck.build(specs_builder.builder) do |check_builder|
            check_builder.with_type("ID_DOCUMENT_AUTHENTICITY").with_config
          end
          Yoti::DocScan::SessionSpecification::RequestedCheck.build(specs_builder.builder) do |check_builder|
            check_builder.with_type("LIVENESS").with_config({liveness_type: "ZOOM", max_retries: 3})
          end
          Yoti::DocScan::SessionSpecification::RequestedCheck.build(specs_builder.builder) do |check_builder|
            check_builder.with_type("ID_DOCUMENT_FACE_MATCH").with_config({manual_check: "FALLBACK"})
          end
        }
        .with_requested_tasks {
          Yoti::DocScan::SessionSpecification::RequestedTask.build(specs_builder.builder) do |task_builder|
            task_builder.with_type("ID_DOCUMENT_TEXT_DATA_EXTRACTION").with_config({manual_check: "FALLBACK"})
          end
        }
        .with_sdk_config {
          Yoti::DocScan::SessionSpecification::SdkConfig.build(specs_builder.builder) do |sdk_builder|
            sdk_builder.with_allowed_capture_methods("CAMERA_AND_UPLOAD")
              .with_primary_colour("#2d9fff")
              .with_preset_issuing_country("USA")
              .with_success_url("https://yourdomain.example/success")
              .with_error_url("https://yourdomain.example/error")
          end
        }
    end

    sample = File.read(support_dir / "doc_scan_example.json")
    sepcs.to_s.should eq(sample)
  end
end
