class EhealthController < ApplicationController
  before_action :authenticate_user!, except: [:index, :aboutus]

  def index
  end

  def aboutus
  end

end
