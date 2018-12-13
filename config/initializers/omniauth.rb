Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_v2_auth,
    ENV['OFFICE_365_OAUTH_CLIENT'],
    ENV['OFFICE_365_OAUTH_SECRET'],
    setup: lambda { |env|
      tenant = ENV['OFFICE_365_OAUTH_TENANT']
      env['omniauth.strategy'].options[:client_options] = {
        site: 'https://login.microsoftonline.com',
        authorize_url: "#{tenant}/oauth2/v2.0/authorize",
        token_url: "#{tenant}/oauth2/v2.0/token"
      }
    }
end
