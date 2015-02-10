$: << 'cf_spec'
require 'cf_spec_helper'

describe 'For all supported Ruby versions' do
  shared_examples 'a Sinatra app' do
    let(:app) { Machete.deploy_app("rubies/tmp/#{ruby_version}") }
    let(:browser) { Machete::Browser.new(app) }

    specify do
      generate_app(ruby_version)
      assert_ruby_version_installed(ruby_version)
      assert_root_contains('Hello, World')
      assert_offline_mode_has_no_traffic
    end
  end

  context 'Ruby 1.9.3' do
    let(:ruby_version) { '1.9.3' }

    it_behaves_like 'a Sinatra app'
  end

  context 'Ruby 2.0.0' do
    let(:ruby_version) { '2.0.0' }

    it_behaves_like 'a Sinatra app'
  end

  context 'Ruby 2.1.0' do
    let(:ruby_version) { '2.1.0' }

    it_behaves_like 'a Sinatra app'
  end

  context 'Ruby 2.2.0' do
    let(:ruby_version) { '2.2.0' }

    it_behaves_like 'a Sinatra app'
  end


  def evaluate_erb(file_path, our_binding)
    template = File.read(file_path)
    f = File.open(file_path, 'w')
    f << ERB.new(template).result(our_binding)
    f.close
  end

  def assert_offline_mode_has_no_traffic
    expect(app.host).not_to have_internet_traffic if Machete::BuildpackMode.offline?
  end

  def generate_app(ruby_version)
    origin_template_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'rubies', 'sinatra')
    copied_template_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'rubies', 'tmp', ruby_version)
    FileUtils.rm_rf(copied_template_path)
    FileUtils.cp_r(origin_template_path, copied_template_path)

    evaluate_erb(File.join(copied_template_path, 'Gemfile'), binding)
    evaluate_erb(File.join(copied_template_path, 'package.sh'), binding)
  end

  def assert_ruby_version_installed(ruby_version)
    expect(app).to be_running
    expect(app).to have_logged "Using Ruby version: ruby-#{ruby_version}"
  end

  def assert_root_contains(text)
    browser.visit_path('/')
    expect(browser).to have_body(text)
  end
end
