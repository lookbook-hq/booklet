# frozen_string_literal: true

module Booklet
  class AnonNode < Node
    include Locatable

    match { true } # fallback entity node type
  end
end
