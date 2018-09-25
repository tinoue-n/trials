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

    if @errors != []
      @cards  = params[:cards]
      @errors = @errors[0][:error]
      render action: :index
    else
      check_cards(params[:cards])
      @cards = params[:cards]
      render action: :index
    end
  end
end
