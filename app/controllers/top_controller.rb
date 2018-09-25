class TopController < ApplicationController
  include CheckCardsHelper
  include ValidationCheckHelper

  def index
    if @cards == nil
      @cards = 'D1 D10 S9 C5 C4'
    end
  end

  def check

    # 入力値チェック
    validate_cards(params[:cards])

    if @error.present?
      @cards  = params[:cards]
      @error = @error[:error]
      render action: :index
    else
      check_cards(params[:cards])
      @cards = params[:cards]
      render action: :index
    end
  end
end
