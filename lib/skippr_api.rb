require 'digest/md5'
require 'singleton'

module SkipprApi

  # Authenticates requests for the skippr API
  class AuthFactory
    include Singleton

    attr_reader :secure
    attr_reader :domain
    attr_reader :port
    attr_reader :app_key
    attr_reader :app_secret

    def self.setup(config)
      self.instance.setup_i(config)
    end

    def self.for_user(client, user_key, user_secret,valid_until = Date.tomorrow.end_of_day)
      self.instance.for_user_i(client, user_key, user_secret, valid_until)
    end


    def setup_i(config)
      @domain = config['domain']
      @app_secret = config['app_secret']
      @app_key = config['app_key']
      @port =
        (config['port'].present?)?config['port']:false
      @secure =
        (config['secure'].present?)?config['secure']:false
    end

    def for_user_i(
      client,
      user_key, 
      user_secret,
      valid_until)
      Auth.new(@app_key, @app_secret, user_key, user_secret, client, valid_until, @domain, @port, @secure)
    end

  end


  class Auth
    attr_reader :secure
    attr_reader :domain
    attr_reader :signature
    attr_reader :app_key
    attr_reader :user_key

    def initialize(
        app_key, 
        app_secret, 
        user_key, 
        user_secret, 
        client, 
        valid_until = Date.tomorrow.end_of_day,
        domain = 'skippr.com',
        port = nil,
        secure = true)
      @domain = domain
      @app_key = app_key
      @user_key = user_key
      @client = client
      sig_src = app_secret + ":" + user_secret + ":" + valid_until.to_time.to_i.to_s
      @signature = Digest::MD5.hexdigest(sig_src)
      @secure = secure
    end

    def host
      host = ((@secure)?'https':'http') + "://" + @client + '.' + @domain + ((@port.present?)?(":" + @port.to_s):"") + "/"
    end

  end


  class Base < ActiveResource::Base

  end

  class ServiceType < Base

  end

end
