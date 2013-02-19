require 'active_support/core_ext'

module Configurator
  extend ActiveSupport::Concern

  included do
    class << self
      attr_accessor :config_path, :prefix
    end
  end

  module ClassMethods

    def config_file(filename, options = {})
      @config_path = Rails.root.join('config', filename)
      @config_file_options = { rails_env: true }.merge(options)
      @prefix = File.basename(filename, '.yml').upcase
    end

    def config_accessor(*attributes)
      @config_attributes = attributes
    end

    def method_missing(*args)
      method_name = args.shift.to_sym

      if @config_attributes && @config_attributes.include?(method_name)
        yaml_options[method_name] == 'env_var' ? ENV["#{@prefix}_#{method_name.to_s.upcase}"] : yaml_options[method_name]
      else
        if yaml_options[method_name].nil?
          super(method_name, *args)
        else
          Rails.logger.info "[DEPRECATION] Please add :#{method_name} to the 'config_accessor' list."
          yaml_options[method_name]
        end
      end
    end

    def respond_to?(*args)
      method_name = args.shift.to_sym

      (@config_attributes || []).include?(method_name) || yaml_options[method_name] || super(method_name, args)
    end

    def yaml_options
      if Rails.env == 'test'
        load_config_from_yaml_file
      else
        @yaml_options ||= load_config_from_yaml_file
      end
    end

    private

    def load_config_from_yaml_file
      hash = if @config_file_options[:rails_env]
        YAML.load_file(@config_path)[Rails.env.to_s]
      else
        YAML.load_file(@config_path)
      end
      HashWithIndifferentAccess.new(hash)
    end

  end
end
