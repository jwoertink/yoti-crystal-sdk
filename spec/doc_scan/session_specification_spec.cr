require "../spec_helper"

describe Yoti::DocScan::SessionSpecification do
  it "builds the appropriate JSON" do
    sepcs = Yoti::DocScan::SessionSpecification.build do |builder|
      builder.with_client_session_token_ttl(600)
        .with_resources_ttl(604800)
        .with_user_tracking_id("<YOUR_USER_ID>")
        .with_notifications do |b|
          Yoti::DocScan::SessionSpecification::Notifications.build(b) do |nb|
            nb.with_endpoint("https://yourdomain.example/idverify/updates")
          end
        end
    end

    sample = File.read(support_dir / "doc_scan_example.json")
    sepcs.to_s.should eq(sample)
  end
end
