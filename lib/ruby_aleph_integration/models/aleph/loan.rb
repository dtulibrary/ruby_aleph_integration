module Aleph
  class Loan < Hash
    def renew
      @@connection.x_request(
        'renew',
        'library' => config.adm_library,
        'doc-number' => self['z36-doc-number'],
        'item-sequence' => self['z36-item-sequence'],
      ).success?
    end
  end
end
