::CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY'], #ClearCMS.config.aws_access_key,       # required
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'] #ClearCMS.config.aws_secret_access_key,       # required
    #:region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV['FOG_DIRECTORY'] #Sidekiq is somehow loading the defaults, must be load order or thread issue?? #ClearCMS.config.fog_directory                     # required
  config.asset_host       = ClearCMS.config.asset_host            # optional, defaults to nil
  #config.fog_public     = true                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

::CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Z0-9\.\-_]/