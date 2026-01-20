module TestUtils
  def flatten_tree_hash(hash)
    entries = []
    entries << hash.except(:children)
    if hash.key?(:children)
      hash[:children].each { entries.push(*flatten_tree_hash(_1)) }
    end
    entries.flatten.compact
  end

  def replace_string_in_file(path, str, replacement)
    file = File.open(path)
    contents = file.read
    File.write(path, contents.gsub(str, replacement))
  end

  extend self
end
