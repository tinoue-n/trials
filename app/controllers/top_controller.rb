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
      @message = "カードのソートと数字を半角スペース区切りで5枚分入力してください"
      @cards   = params[:cards]
      render action: :index
    elsif params[:cards].split.size != params[:cards].split.uniq.size
      @message = "カードが重複しています"
      @cards   = params[:cards]
      render action: :index
    else

      check_cards(params[:cards])

      @cards = params[:cards]
      render action: :index
    end
  end
end
