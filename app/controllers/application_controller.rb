class ApplicationController < ActionController::Base
  include Slimmer::GovukComponents

  protect_from_forgery with: :exception
end
