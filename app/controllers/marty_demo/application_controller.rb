class MartyDemo::ApplicationController < Marty::ApplicationController
  protect_from_forgery

  layout "marty_demo/application"
end
