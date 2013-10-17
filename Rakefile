require "rake/testtask"
require "rubygems/package_task"

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.test_files = Dir["test/**/*_test.rb"]
  t.verbose = true
end

gemspec = File.expand_path("../html_email_builder.gemspec", __FILE__)
if File.exist? gemspec
  Gem::PackageTask.new(eval(File.read(gemspec))) { |pkg| }
end

def gemfiles
  @gemfiles ||= begin
    Dir[File.dirname(__FILE__) + '/test/gemfiles/Gemfile.*'].
      reject {|f| f =~ /\.lock$/}.
      reject {|f| RUBY_VERSION < '1.9.3' && f =~ /master/}
  end
end

def with_each_gemfile
  old_env = ENV['BUNDLE_GEMFILE']
  gemfiles.each do |gemfile|
    puts "Using gemfile: #{gemfile}"
    ENV['BUNDLE_GEMFILE'] = gemfile
    yield
  end
ensure
  ENV['BUNDLE_GEMFILE'] = old_env
end

namespace :test do
  namespace :bundles do
    desc "Install all dependencies necessary for testing."
    task :install do
      with_each_gemfile {sh "bundle"}
    end

    desc "Update all dependencies for testing."
    task :update do
      with_each_gemfile {sh "bundle update"}
    end
  end

  desc "Test all supported versions of Haml. This takes a while."
  task :haml_compatibility => 'test:bundles:install' do
    with_each_gemfile {sh "bundle exec rake test"}
  end
  task :hc => :haml_compatibility
end
