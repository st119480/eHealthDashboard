#
# Author: taureanamir 
# Created On: 4/3/18.
#

module Api
  module V1
    class TestController < ApplicationController
      respond_to :json

      def create
        respond_with Test.create(params[:test_params])
      end
    end
  end
end
