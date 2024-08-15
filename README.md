# yoti-crystal-sdk

This is a Crystal shard for integrating with [Yoti](https://www.yoti.com/) for identification verification.

API documentation can be found on [Yoti Developers](https://developers.yoti.com/) guide.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     yoti:
       github: jwoertink/yoti-crystal-sdk
   ```

2. Run `shards install`

## Usage

```crystal
require "yoti"

Yoti.configure do |config|
  config.client_sdk_id = ENV["YOTI_CLIENT_SDK_ID"]
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
end

payload = Yoti::DocScan::SessionSpecification.build do |specification|
  specification.with_user_tracking_id("<YOUR_USER_ID>")
    .with_requested_checks {
      Yoti::DocScan::SessionSpecification::RequestedCheck.build(specification.builder) do |requested_check|
        requested_check.with_type("ID_DOCUMENT_AUTHENTICITY").with_config
      end
      Yoti::DocScan::SessionSpecification::RequestedCheck.build(specification.builder) do |requested_check|
        requested_check.with_type("LIVENESS").with_config({liveness_type: "ZOOM", max_retries: 3})
      end
    }
end

session = Yoti::DocScan::Client.new.create_session(payload)

# Render the form
iframe_url = "#{Yoti.doc_scan_api_endpoint}/web/index.html?sessionID=#{session.session_id}&sessionToken=#{session.client_session_token}"

# Find an existing session
session = Yoti::DocScan::Client.new.find_session(session.client_session_token)

# Fetch specific media content
media = Yoti::DocScan::Client.new.get_media_content(session.session_id, media_id)
```


## Development

* write code
* write spec
* crystal tool format spec/ src/
* ./bin/ameba
* crystal spec
* repeat

## Contributing

1. Fork it (<https://github.com/jwoertink/yoti-crystal-sdk/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer
