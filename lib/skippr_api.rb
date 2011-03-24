require 'digest/md5'
require 'singleton'
require 'active_support/json'
require "net/http"
require "uri"

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
    attr_reader :valid_until

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
      sig_src = user_secret + ":" + app_secret + ":" + valid_until.to_time.to_i.to_s
      @port = port
      @signature = Digest::MD5.hexdigest(sig_src)
      @secure = secure
      @valid_until = valid_until
    end



    def host
      host = ((@secure)?'https':'http') + "://" + @client + '.' + @domain + ((@port.present?)?(":" + @port.to_s):"") + "/api/v1/"
    end

    def query_params
      {:app => @app_key, :user => @user_key, :validuntil => @valid_until.to_time.to_i.to_s, :signature => @signature}
    end

    def valid?
       # raise host + 'auth/valid?' + query_params.to_param 
      #begin
        uri = URI.parse(host + 'auth/valid?' + query_params.to_param)
        http = Net::HTTP.new(uri.host, uri.port)
        response = http.request(Net::HTTP::Get.new(uri.request_uri))
        #raise host + 'auth/valid?' + query_params.to_param + '    :' +  Net::HTTP.get_print(uri)  
        response.code == '200' && response.read_body == 'OK'
      #rescue
      #  false
      #end

    end

  end

  module MyJson
      extend self 
      def extension
        "json"
      end

      def mime_type
        "application/json"
      end

      def encode(hash, options={})
        hash.to_json(options)
      end

      def decode(json)
        ActiveSupport::JSON.decode(json)
      end
  end  

  class ApiResource < ActiveResource::Base
          include_root_in_json = false      

          def self.auth=(auth)
            @@auth = auth
          end

          def self.auth
            @@auth
          end

          self.format = MyJson
          class << self
            def element_path(id, prefix_options = {}, query_options = nil)
              prefix_options, query_options = split_options(prefix_options) if query_options.nil?
              query_options = ( query_options.nil? ) ? self.auth : query_options.merge(self.auth)
              "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
            end

            def collection_path(prefix_options = {}, query_options = nil)
              prefix_options, query_options = split_options(prefix_options) if query_options.nil?
              query_options = ( query_options.nil? ) ? self.auth : query_options.merge(self.auth)
              "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
            end

          end

  end


  class ApiFactory
    #
    # Creates a module that serves as an ActiveResource
    # client for the specified user
    #
    def self.create_api(auth)
      # specify the site.  Default to no credentials
      @url_base = auth.host
      # build a module name.  This assumes that logins are unique.
      # it also assumes they're valid ruby module names when capitalized
      @module = auth.user_key.capitalize
      @params = auth.query_params
      class_eval <<-"end_eval",__FILE__, __LINE__
      module #{@module}
        class AuthBasedResource < ApiResource
          self.site = "#{@url_base}"
          self.auth = {
            :app => "#{auth.app_key}",
            :user => "#{auth.user_key}",
            :validuntil => "#{auth.valid_until.to_time.to_i.to_s}",
            :signature => "#{auth.signature}",
          }
        end

        class Invoice < AuthBasedResource
        end

        class InvoicePosition < AuthBasedResource
          
        end

        class ServiceType < AuthBasedResource
        end

        class Customer < AuthBasedResource
        end

        # return the module, not the last site String
        self
      end
      end_eval
    end
  end



end
