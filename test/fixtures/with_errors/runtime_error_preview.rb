module SubFolder
  class RuntimeErrorPreview < Lookbook::Preview
    def default
      call_nonexistant_method "Runtime error, not syntax error"
    end
  end
end
