include CheckCardsHelper
class TopController < ApplicationController
  def index
    if @cards == nil
      @cards = 'D1 D10 S9 C5 C4'
    end
  end

  def check

    # 入力値チェック
    if params[:cards] !~ /\A([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])\z/
      @message = "ちゃんと入力せい（例：H9 C9 S9 H1 C1）"
      @cards   = params[:cards]
      render action: :index
    else

      check_cards(params[:cards])

      @cards = params[:cards]
      render action: :index
    end
  end
end
