class Orion::ApplicationController < Marty::ApplicationController
  protect_from_forgery

  layout "orion/application"
end
