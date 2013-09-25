module Aleph
  class Shortdoc < Hash
    def title
      self['z13-title']
    end

    def author
      self['z13-author']
    end
  end
end
