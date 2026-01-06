class SyntaxErrorPreview < Lookbook::Preview
  def default
    render html: "this file has a syntax error in it"
  ends
end
