require "./spec_helper"

describe Yoti::SSL do
  describe "#sign" do
    it "returns base64 encoded string" do
      private_pem = File.read(support_dir / "test_key.pem")
      ssl = Yoti::SSL.new(private_pem)
      # qxKmJBuIaq1Rpq+NkKOHrNwlrXmS7U0loi2wWCutIRWzlrAnnvEzfkK3G6UB05Y1yPqqbv0Kwm3CPomuUmAkqQJbYpRFeausOKXsz/HLbt78bz4y9bUKdh7xndX0wqN42kVYbFiBwWHmTnpFhZiHb6TtE7+IwGeco7EhwvS5oIlBc/3bfGpZyDQItidHWvECiB55ZOnvYDaGzafa1+w/OFAnVpZoHqYB+a/TmKbYbWH67zg+8OiMvrR/ZdhHmjezwYS7autmWyaZIP91Utzq/MER0zWOA+n/KJ9cIgRSpLcSJnqSZaNAvBCDnJ1P+7GwtczoysRss1bPUB2T5qui7g==
      signature = ssl.sign(message)
      Base64.decode_string(signature).should_not eq(nil)
    end
  end

  describe "verify" do
    it "returns true for valid signatures" do
      public_pem = File.read(support_dir / "test_pub.pem")
      signature = "qxKmJBuIaq1Rpq+NkKOHrNwlrXmS7U0loi2wWCutIRWzlrAnnvEzfkK3G6UB05Y1yPqqbv0Kwm3CPomuUmAkqQJbYpRFeausOKXsz/HLbt78bz4y9bUKdh7xndX0wqN42kVYbFiBwWHmTnpFhZiHb6TtE7+IwGeco7EhwvS5oIlBc/3bfGpZyDQItidHWvECiB55ZOnvYDaGzafa1+w/OFAnVpZoHqYB+a/TmKbYbWH67zg+8OiMvrR/ZdhHmjezwYS7autmWyaZIP91Utzq/MER0zWOA+n/KJ9cIgRSpLcSJnqSZaNAvBCDnJ1P+7GwtczoysRss1bPUB2T5qui7g=="
      ssl = Yoti::SSL.new(public_pem)
      ssl.verify(signature, message).should eq(true)
    end
  end
end

private def message : String
  payload = {"user_tracking_id" => "abc123"}
  base64_payload = Base64.strict_encode(payload.to_json)
  "POST&/sessions?sdkId=...&#{base64_payload}"
end
