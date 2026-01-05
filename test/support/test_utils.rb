module TestUtils
  def flatten_tree_hash(hash)
    entries = []
    entries << hash.except(:children)
    if hash.key?(:children)
      hash[:children].each { entries.push(*flatten_tree_hash(_1)) }
    end
    entries.flatten.compact
  end

  extend self
end
