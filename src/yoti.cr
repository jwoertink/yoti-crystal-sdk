require "http/client"
require "json"
require "base64"
require "uuid"
require "openssl_ext"
require "habitat"
require "./yoti/**"

module Yoti
  VERSION = "0.1.0"

  Habitat.create do
    setting client_sdk_id : String
    setting key_file_path : String, example: "./path/to/key.pem"
    setting key : String? = nil
    setting sdk_identifier : String = "Crystal"
    setting api_url : String = "https://api.yoti.com"
    setting api_port : Int32 = 443
    setting api_version : String = "v1"
  end

  def self.api_endpoint : String
    "#{settings.api_url}/api/#{settings.api_version}"
  end

  def self.doc_scan_api_endpoint : String
    "#{settings.api_url}/idverify/#{settings.api_version}"
  end
end
