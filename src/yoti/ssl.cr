module Yoti
  class SSL
    def initialize(@pem : String)
    end

    def sign(message : String) : String
      private_key = OpenSSL::PKey::RSA.new(@pem)
      digest = OpenSSL::Digest.new("SHA256")
      signature = private_key.sign(digest, message)
      Base64.strict_encode(signature)
    end

    def verify(encoded_signature : String, original_message : String) : Bool
      public_key = OpenSSL::PKey::RSA.new(@pem, is_private: false)
      digest = OpenSSL::Digest.new("SHA256")
      signature = Base64.decode_string(encoded_signature)
      public_key.verify(digest, signature, original_message)
    end
  end
end
