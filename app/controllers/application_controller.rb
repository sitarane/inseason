class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[ show index ]
end
