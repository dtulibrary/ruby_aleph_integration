require 'nokogiri'

module Aleph
  class Base
    def config
      Aleph::config
    end

    def parse(nodes)
      parse_objects('Hash', nodes)
    end

    def parse_objects(klass, nodes)
      all = Array.new
      nodes.each do |top|
        result = klass.constantize.new
        top.element_children.each do |node|
          #logger.info "Node: #{node.name}, #{node.type}, #{node.element_children}"
          if node.element_children.empty?
            result[node.name] = node.text
          end
        end
        all << result
      end
      all
    end

    def parse_group_objects(nodes)
      all = Array.new
      nodes.each do |top|
        item = nil
        doc = nil
        result = nil
        top.element_children.each do |group|
          case group.name
          when 'z30'
            item = config.aleph_item_class.constantize.new
            store = item
          when 'z13'
            doc = config.aleph_short_doc_class.constantize.new
            store = doc
          when 'z37'
            result = config.aleph_hold_class.constantize.new
            store = result
          when 'z31'
            result = config.aleph_cash_class.constantize.new
            store = result
          when 'z36'
            result = config.aleph_loan_class.constantize.new
            store = result
          else
            logger.warn "Handle #{group.name}"
          end
          group.element_children.each do |node|
            if node.element_children.empty?
              store[node.name] = node.text
            end
          end
        end
        unless result.nil?
          result['title'] = doc.title
          result['author'] = doc.author
          result['barcode'] = item.barcode
          all << result
        end
      end
      all
    end

    def logger
      Rails.logger
    end
  end
end
