module FixtureHelpers
  def fixture_file(path)
    Pathname(::File.dirname(__FILE__)).join("../fixtures").join(path).expand_path
  end

  def fixture_dir_child_count(path)
    Dir[%(#{fixture_file(path)}/*)].size
  end

  def fixture_dir_descendant_count(path)
    Dir[%(#{fixture_file(path)}/**/*)].size
  end

  extend self
end
