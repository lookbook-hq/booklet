module FixtureHelpers
  def fixture_file(path)
    Pathname(::File.dirname(__FILE__)).join("../fixtures").join(path).expand_path
  end

  def fixture_file_children(path)
    Dir[%(#{fixture_file(path)}/*)].map { Pathname(_1) }
  end

  def fixture_file_descendants(path)
    Dir[%(#{fixture_file(path)}/**/*)].map { Pathname(_1) }
  end

  extend self
end
