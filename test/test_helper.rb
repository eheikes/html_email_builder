require 'minitest/autorun'
require 'haml'
require 'html_email_builder'

Haml::Options.defaults[:format] = :xhtml
Haml::Options.defaults[:remove_whitespace] = true

class MiniTest::Unit::TestCase

  def render(text, options = {}, base = nil, &block)
    scope  = options.delete(:scope)  || Object.new
    locals = options.delete(:locals) || {}
    engine = Haml::Engine.new(text, options)
    return engine.to_html(base) if base
    html = engine.to_html(scope, locals, &block)
    html.gsub!(/\s+$/, '')  # strip trailing whitespace
    html.gsub!(/\n+/, "\n") # strip empty lines
    html += "\n"            # add linebreak to match heredoc in tests
    return html
  end

end
