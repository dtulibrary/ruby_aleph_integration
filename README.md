ruby_aleph_integration
======================

Ruby integration gem for Aleph ILS from ExLibris.


Bibliographic lookups
---------------------

  bib = Aleph::Bibliographic(docno)

    Create a representation of a bibliographic record.
    docno is the system number in the bibliographic database.

  Once you have a bibliographic object you may perform the operations
  list below.
  All operations will return a different result whether or not the
  items are complex or not.
  Complex items are periodicals and multi volumes book.
  All operations return a hash with a key of either simple or mutiple,
  for these 2 cases.
  Each operation will describe the value in the key.

  availability

    Simple: Hash with the keys normal and textbook.
    Mutiple: Array of hashes as with simple, but also a description key.

    normal and textbook will contain a status code (see below).
    This will be the best result if multiple options are available.

  holding

    Simple: Hash with sub-library as key and each element will be a hash
    as for availability simple.
    Multiple: Hash with sub-library as key and an array of elements

  full_holding

    This will return the full holding for each sub-library/collection
    combination, including specific counts.
    Simple: Array of holdings
    Multiple: Array of Array of holdings

Status codes
------------

   available    The item is available for loan.
   request      The item can be requested for use in the library (reading room).
   on-loan      The item is on-loan at the moment.
   restricted   The item has restriction on its use.
   limited      The item is available outside of library, but limits apply
   unavailable  The item is unavailable
   unknown      No status was found

User lookup
-----------

  user = Aleph::Borrower(user-object)

  Tries to find a user which matches the given user object.
  If no user can be found in Aleph a new user is created.
  If a user is found, Aleph is updated if needed.

  User object must respond to a number of well defined functions
    id
      - Id number of the user
    address_lines
      - Array of address lines
    email
      - E-mail address of user (string value)
    aleph_bor_status_type
      - Aleph borrowe status and type for the given user

  Optional functions
    The data will be used if they are available
  
    birth_day
      - Date of birth (YYYYMMDD format)
    gender
      - Gender of user (M = Male, F = Female)
    aleph_ids
      - Array of hash with type, id fields
        Will be used to create addtional z308 entries in aleph.
        Will also be used to find an existing user.

  See lib/ruby_aleph_integration/models/user.rb for more information.

Config
------

  Config are done with:

  Aleph.setup do |config|
    config.aleph_x_url = 'https://aleph-server'
  end

  For more details see lib/ruby_aleph_integration.rb file.
  All accessors defined with mattr_accessor can be configured.

