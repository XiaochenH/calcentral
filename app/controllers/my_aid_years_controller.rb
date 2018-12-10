class MyAidYearsController < ApplicationController
  include AllowDelegateViewAs
  before_filter :api_authenticate_401
  before_filter :authorize_for_financial

  def get_feed
    render json: FinancialAid::MyAidYears.from_session(session).get_feed_as_json
  end

end
