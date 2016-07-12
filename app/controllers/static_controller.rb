class StaticController < ApplicationController
  skip_before_filter :authenticate_user
  def index
    render text: nil, layout: true
  end
end
