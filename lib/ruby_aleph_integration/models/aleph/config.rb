module Aleph
  class Config
    include Singleton

    # Configuration variables
    #   aleph_url     Url for Aleph server
    #   bib_library   Default bibliographic library
    #   adm_library   Default administration library
    #   bor_prefix    Prefix for borrower id
    #   bor_type_id   Borrower Type Id used
    #   user_type_map Mapping between user type and aleph user type.
    #   user_status_map Mapping between user status and aleph user status.
    #   z303_defaults
    #     home_library
    #     ill_library
    #   z304_defaults
    #   z305_defaults
    #
    #   aleph_bor     Class which handles broowers
    #
    #   A borrower is looked up as follows
    #     Z308-TYPE  = bor_id_type
    #     Z308-VALUE = bor_prefix + id given
    #

    def initialize
      @@config ||= OrderedOptions.new
      @@config.aleph_bor  ||= "Aleph::Borrower"
      @@config.aleph_bib  ||= "Aleph::Bibliographic"
      @@config.aleph_item ||= "Aleph::Item"
    end

    def setup(&block)
      yield &block
    end

  #  def method_missing
  #  end
  end
end
