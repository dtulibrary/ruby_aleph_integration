module Aleph
  class Hold < Hash
    def cancel
      document = @@connection.x_request(
        'hold_req_cancel',
        'library' => config.adm_library,
        'doc_number' => self['z37-doc-number'],
        'item_sequence' => self['z37-item-sequence'],
        'sequence' => self['z37-sequence'],
      ).success?
    end
  end
end
