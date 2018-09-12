class TopController < ApplicationController
  def index
    if session[:cards] == nil
      @cards = 'D1 D10 S9 C5 C4'
    else
      @cards = session[:cards]
    end
    @hand = session[:hand]
  end

  def check

    # 入力値チェック
    if params[:cards] !~ /\A([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])\z/
        flash[:notice] = "ちゃんと入力せい（例：H9 C9 S9 H1 C1）"
        session[:cards] = params[:cards]
        redirect_to action: :index
    else

      # ストレートの判定のためにパターン挙げる
      straight_patterns = [%w[1 2 3 4 5], %w[2 3 4 5 6], %w[3 4 5 6 7], %w[4 5 6 7 8], %w[5 6 7 8 9],
                           %w[6 7 8 9 10], %w[7 8 9 10 11], %w[8 9 10 11 12], %w[9 10 11 12 13], %w[10 11 12 13 1]]

      # スートと番号を配列に入れる
      suits   = params[:cards].gsub(/\d+/, "").split
      numbers = params[:cards].gsub(/[a-zA-Z]/, "").split.sort

      # フラッシュかどうかを判定
      if suits.uniq.size == 1
        # ストレートかどうかを判定
        if straight_patterns.include?(numbers)
          session[:hand] = "ストレートフラッシュ"
        else
          session[:hand] = "フラッシュ"
        end
      else
        # ストレートを先に判定
        if straight_patterns.include?(numbers)
          session[:hand] = "ストレート"
        else
          # 同じ数字のカードの枚数を数えて配列にして役を判定する
          arr = numbers.uniq.map {|e| numbers.count(e)}.sort
          case arr
          when [1, 4]
            session[:hand] = "フォー・オブ・ア・カインド"
          when [2, 3]
            session[:hand] = "フルハウス"
          when [1, 1, 3]
            session[:hand] = "スリー・オブ・ア・カインド"
          when [1, 2, 2]
            session[:hand] = "ツーペア"
          when [1, 1, 1, 2]
            session[:hand] = "ワンペア"
          when [1, 1, 1, 1, 1]
            session[:hand] = "ハイカード"
          end
        end
      end
      session[:cards] = params[:cards]
      redirect_to action: :index
    end
  end
end
