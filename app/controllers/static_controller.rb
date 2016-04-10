class StaticController < ApplicationController
  def index
    render text: nil, layout: true
  end
end
