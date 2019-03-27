require 'json'

OmniAuth.config.logger = Rails.logger
google_data = JSON.parse(File.read('credentials_oauth.json'))["web"]


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, google_data["client_id"], google_data["client_secret"]#, {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end