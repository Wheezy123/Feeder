class Api::V1::FeedEntriesController < ApplicationController
  respond_to :json

  def show
    @stories = FeedEntry.all

    render json: @stories
  end
end
