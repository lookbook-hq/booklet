module Booklet
  # Double-dispatch node visitor base class. Adapted from the Refract gem (https://github.com/yippee-fun/refract).
  #
  # @see https://github.com/yippee-fun/refract/blob/main/lib/refract/basic_visitor.rb
  class Visitor < Booklet::Object
    include Callbackable

    after_initialize do
      @stack = []
    end

    def visit(node)
      return unless node

      @stack.push(node)
      node.accept(self).tap { @stack.pop }
    end

    def visit_each(nodes)
      nodes.compact.each { visit(_1) }
    end

    def method_missing(name, node)
      if name.start_with?("visit_")
        visit_each(node.children) if node.children?
        node
      else
        super
      end
    end

    def respond_to_missing?(name, ...)
      name.start_with?("visit_") || super
    end

    class << self
      def node(node_class, &)
        define_method("visit_#{node_class.type}", &)
      end
    end
  end
end
