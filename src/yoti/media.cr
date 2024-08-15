module Yoti
  class Media
    property content : String
    property mime_type : String

    def initialize(@content : String, @mime_type : String)
    end
  end
end
