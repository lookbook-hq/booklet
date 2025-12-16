# frozen_string_literal: true

module Booklet
  class AnonNode < EntityNode
    match { true } # fallback entity node type
  end
end
