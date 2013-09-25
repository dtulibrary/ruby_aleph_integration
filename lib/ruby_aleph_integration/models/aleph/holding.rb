module Aleph
  class Holding < Hash
    def initialize
      self['available'] ||= 0
      self['unavailable'] ||= 0
    end

    def translate
      translation_fields.each do |k|
        self["translated-#{k}"] = (self[k].blank? ? '' :
          I18n.t(self[k], :scope => "aleph.item.#{k}", :default => self[k]))
      end
    end

    def translation_fields
      %w(sub-library collection)
    end

    def status
      return 'available' if self['available'] > 0
      return 'on-loan' if (self['on-loan'] || 0) > 0
      return 'unavailable'
    end
  end
end

