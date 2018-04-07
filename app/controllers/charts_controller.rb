class ChartsController < ApplicationController
  def all_tests
    render json: Test.group_by_month(:test_date).count
  end

  # def chart
  #   @chart_data = Test.map{ |m| [name: m['testdate'], data: m['bmi']]}.flatten
  #   line_chart @chart_data.each do |m|
  #     [{name: [:name], data: [:data]}]
  #   end
  # end
  #

  def chart
    @chart_data = Test.all
    # # , data: m['bmi'], data: m['pulse_rate'], data: m['body_temperature']]}.flatten
    # id = JSON.parse(@chart_data)['id']
    render json: @chart_data
  end
end

