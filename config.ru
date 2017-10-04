require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'
  set :ewsEndpoint, 'https://outlookanywhere.kuleuven.be/EWS/Exchange.asmx'
  set :ewsUser, 'u0105303@kuleuven.be'
  set :ewsPassword, 'N8eywV9e1718'
  set :timeZoneBias, 60

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
