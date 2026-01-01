module FixtureHelpers
  ASSET_EXTENSIONS = [".js", ".css", ".png", ".svg", ".gif", ".jpg", ".webp", ".jpeg"]

  def fixture_file(path)
    Pathname(::File.dirname(__FILE__)).join("../fixtures").join(path).expand_path
  end

  def fixtures_within(dir, recursive: true)
    Dir[%(#{fixture_file(dir)}/#{"**/" if recursive}*)].map { Pathname(_1) }
  end

  def asset_fixtures_within(dir)
    fixtures_within(dir).select { _1.extname.to_s.in?(ASSET_EXTENSIONS) }
  end

  def markdown_fixtures_within(dir)
    fixtures_within(dir).select do |pathname|
      pathname.basename.to_s.match?(/\.(md|md\.erb)$/)
    end
  end

  def preview_class_fixtures_within(dir)
    fixtures_within(dir)
      .select { _1.basename.to_s.end_with?("_preview.rb") }
  end

  def folder_fixtures_within(dir)
    fixtures_within(dir).select { _1.directory? }
  end

  def entity_fixtures_within(dir)
    asset_fixtures_within(dir) +
      markdown_fixtures_within(dir) +
      preview_class_fixtures_within(dir) +
      folder_fixtures_within(dir)
  end

  def anon_fixtures_within(dir)
    fixtures_within(dir) - entity_fixtures_within(dir)
  end

  extend self
end
