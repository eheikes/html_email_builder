Gem::Specification.new do |s|
  s.name        = "html_email_builder"
  s.version     = "0.1.0"
  s.date        = "2013-09-16"
  s.summary     = "Helpers for creating HTML emails"
  s.description = "html_email_builder is an easy way to create HTML emails."
  s.author      = "Eric Heikes"
  s.email       = "eheikes@gmail.com"
  s.files       = ["lib/html_email_builder.rb"]
  s.homepage    = "https://github.com/eheikes/html_email_builder"
  s.license     = "Apache-2.0"
  s.test_files  = Dir.glob('test/*_test.rb')

  s.required_ruby_version = '>= 1.8.7'

  s.add_dependency 'activesupport', '>= 1.0.0'
  s.add_dependency 'haml', '>= 3.2.0'

  s.add_development_dependency 'rake', '>= 0'
end
