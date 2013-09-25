module Aleph
  class Item < Hash
    def multi_level?
      !multi_level_key.blank?
    end

    def coalation_key
      key = ""
      coalation_keys.each do |k|
        key.concat "#{self[k]}-"
      end
      key += @multi_level_key if multi_level?
      key
    end

    def coalation_keys
      %w(sub-library collection)
    end

    def multi_level_key
      key = ""
      multi_level_keys.each do |k|
        key.concat "#{self[k]}-"
      end
      @multi_level_key = (key == '------' ? '' : key)
    end

    def multi_level_keys
      %w(chronological-i chronological-j chronological-k
         enumeration-a enumeration-b enumeration-c)
    end

    def translate
      translation_fields.each do |k|
        self["translated-#{k}"] = (self[k].blank? ? '' :
          I18n.t(self[k], :scope => "aleph.item.#{k}"))
      end
    end

    def translation_fields
      %w(sub-library collection)
    end

    def key_description
      if self['chronological-i']
        "#{self['chronological-i']} #{self['enumration-a']}"
      else
        "#{self['enumration-a']} #{self['enumration-b']} "
        "#{self['enumration-c']}"
      end
    end

    def barcode
      self['z30-barcode']
    end

  end
end
