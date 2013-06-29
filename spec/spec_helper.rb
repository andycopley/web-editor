require 'rspec'
require 'rspec/expectations'
require 'rack'
require 'rack/test'
require 'sinatra'
require 'octokit'
require 'git'
require 'fileutils'

require_relative '../app.rb'
require_relative '../helpers/repository'
require_relative '../helpers/link'

APP = Rack::Builder.parse_file(File.join(File.dirname(__FILE__), '..', 'config.ru')).first
GITHUB_AUTH = File.open(File.join(File.dirname(__FILE__), '.github_auth')).readlines[0].split '::'
#$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..')

RSpec.configure do |config|
  ENV['RACK_ENV'] = 'test'
  config.include Rack::Test::Methods

  def app
    APP
  end

  def github_client
    client = Octokit::Client.new(:login => GITHUB_AUTH[0], :oauth_token => GITHUB_AUTH[1])
  end

  config.before(:suite) do
    unless File.exists? (File.join(File.dirname(__FILE__), '..', 'tmp/awestruct.org'))
      Git.clone('git@github.com:awestruct/awestruct.org.git', 'awestruct.org',
                :path => File.join(File.dirname(__FILE__), '..', 'tmp'))
    end
  end
end