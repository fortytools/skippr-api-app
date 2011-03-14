require 'skippr_api'

begin
  config = File.join(Rails.root, "config/skippr_api.yml")

  if File.exist?(config)
    Rails.logger.info "[Starter App] Loading API credentials from config/skippr_api.yml"
  
    config = YAML.load(File.read(config))[Rails.env]
    SkipprApi::AuthFactory::setup(config)
  else
    Rails.logger.warn '[Starter App] No config/skipp_api.yml found.'
  end
end
