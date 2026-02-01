# frozen_string_literal: true

module Booklet
  class ParamSet < Booklet::Object
    include Enumerable

    prop :params, _Array(Param), :positional, reader: :protected, default: -> { [] }

    def update(name, props)
      param = find!(name)
      props.to_h.except(:name).each { param.try("#{_1}=", _2) }
    end

    def push(*params)
      @params.push(*params.flatten)
    end

    def find!(name)
      param = find { _1.name == name }
      raise "Unknown param #{param}" unless param
      param
    end

    delegate :each, to: :@params
    delegate_missing_to :@params
  end
end
