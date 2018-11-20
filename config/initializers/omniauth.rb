Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_v2_auth, ENV['OFFICE_365_OAUTH_CLIENT'], ENV['OFFICE_365_OAUTH_SECRET']
end
