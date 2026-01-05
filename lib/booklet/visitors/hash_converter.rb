# frozen_string_literal: true

module Booklet
  class HashConverter < Visitor
    visit do |node|
      if node.root?
        memo = @hash = @current = node_to_hash(node)
      else
        hash = node_to_hash(node)
        @current[:children].push(hash)

        memo = @current
        @current = hash
      end

      visit_each(node.children)

      @current = memo
      @hash
    end

    protected def node_to_hash(node)
      props = @options.props || []
      props = props.is_a?(Array) ? props.map { [_1, true] }.to_h : props

      hash = props.map do |p, resolver|
        if resolver.is_a?(Proc)
          [p, resolver.call(node)]
        elsif resolver != false && node.respond_to?(p)
          [p, node.public_send(p)]
        end
      end.compact.to_h

      hash.tap do |h|
        h[:ref] = node.ref.value
        h[:type] = node.type.name
      end

      hash[:children] = [] if node.branch?
      hash
    end
  end
end
