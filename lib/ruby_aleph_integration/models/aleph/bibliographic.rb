module Aleph
  class Bibliographic < Base
    def initialize(doc_no)
      @@connection = Aleph::Connection.instance
      @bib_library ||= config.bib_library
      if @bib_library.blank?
        raise Aleph::Error, "BIB library must be specified in configuration"
      end
      @doc_number = doc_no
    end

    def full_holding
      retrieve_holding if @holdings.nil?
      if @multi_holdings
        multi = Array.new
        @multi_holdings.values.each do |holding|
          multi << holding.values
        end
        { 'multiple' => multi }
      else
        { 'single' => @holdings.values }
      end
    end

    # Map holding to sub-library level
    def holding
      retrieve_holding if @holdings.nil?
      if @multi_holdings
        multi = Hash.new
        @multi_holdings.each do |key, group|
           collect_sub_library_level(group).each do |key, holding|
             multi[key] ||= Array.new
             multi[key] << holding
           end
        end
        { 'multiple' => multi }
      else
        { 'single' => collect_sub_library_level(@holdings) }
      end
    end

    def availability
      retrieve_holding if @holdings.nil?
      if @multi_holdings
        multi = Hash.new
        @multi_holdings.each do |key, group|
           multi[key] = collect_top_level(group)
        end
        { 'multiple' => multi.values }
      else
        { 'single' => collect_top_level(@holdings) }
      end
    end

    def multiple_holdings
      retrieve_holdings if @holdings.nil?
      @multi_holdings ? true : false
    end

    private

    def collect_sub_library_level(holdings)
      list = Hash.new
      holdings.each do |k, h|
        list[h['sub-library']] ||= {
          'normal' => 'unknown',
          'textbook' => 'unavailable'
        }
        avail = list[h['sub-library']]
        # Textbooks should be unavailable by definition
        # But in this view they are available at the library.
        if config.textbook_collections.include?(h['collection'])
          avail['textbook'] = 'available'
        else
          if priority(avail['normal']) > priority(h.status)
            avail['normal'] = h.status
          end
        end
        avail['description'] ||= h['description']
        avail['call-number'] ||= h['call-number']
      end
      list
    end

    def collect_top_level(holdings)
      avail = {
        'normal' => 'unknown',
        'textbook' => 'unavailable'
      }
      holdings.each do |k, h|
        # Textbooks should be unavailable by definition
        # But in this view they are available at the library.
        if config.textbook_collections.include?(h['collection'])
          avail['textbook'] = 'available'
        else
          if priority(avail['normal']) > priority(h.status)
            avail['normal'] = h.status
          end
        end
        avail['description'] ||= h['description']
      end
      avail
    end

    def retrieve_holding
      retrieve_items if @z30s.nil?
      # Build holding
      @multi_holdings = nil
      @holdings = Hash.new
      @z30s.each do |z|
       update_holding(z, find_holding(z))
      end
      if @multi_holdings
        @multi_holdings.values.each do |group|
          group.values.each do |holding|
            holding.translate
          end
        end
      else
        @holdings.values.each do |holding|
          holding.translate
        end
      end
    end

    def find_holding(z)
      if z.multi_level?
        @multi_holdings ||= Hash.new
        @multi_holdings[z.multi_level_key] ||= Hash.new
        @multi_holdings[z.multi_level_key][z.coalation_key] ||= Holding.new
      else
        @holdings[z.coalation_key] ||= Holding.new
      end
    end

    def update_holding(z, h)
      z.coalation_keys.each do |k|
        h[k] = z[k]
      end
      h['call-number'] ||= z['call-no-1']
      h['description'] ||= z['description'] || z.key_description
      if(z['loan-status'].nil?)
        status = config.item_mapping[z['item-status']] || 'unavailable'
      else
        status = 'on-loan'
      end
      h[status] ||= 0
      h[status] += 1
    end

    def retrieve_items
      document = @@connection.x_request('item-data',
        'sys_number' => @doc_number,
        'base' => @bib_library,
        'translate' => 'N',
      ).success
      @z30s = parse_objects(
        config.aleph_item_class,
        document.xpath("//item")
      )
#      logger.info "Z30s: #{@z30s.inspect}"
    end

    def priority(status)
      config.priorities[status] || 100
    end
  end
end
