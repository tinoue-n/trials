include CheckCardsHelper
module Cards
  class API < Grape::API
    resource "check" do

      desc "役と最強フラグを返そう"

      params do
        requires :cards
      end

      post do

        # 前処理
        errors     = Array.new
        cards      = params[:cards].each_slice(1).to_a
        result     = Array.new
        @strengths = Array.new

        cards.each do |c|

          # パラメータ形式チェック
          if c.join !~ /\A([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])\z/
            error = {
              cards: c.join,
              error: "カードのソートと数字を半角スペース区切りで5枚分入力してください"
            }
            errors << error
          else

            check_cards(c)

            # カードと判定した役をハッシュにして結果の配列に入れる
            r = {
              cards:    c.join,
              hand:     @hand,
              strength: @strength,
              best:     nil
            }
            result << r
            @strengths << @strength
          end
        end

        # 最強決定戦
        result.each do |r|
          if r[:strength] == @strengths.max
            r[:best] = true
            r.delete(:@strength)
          else
            r[:best] = false
            r.delete(:strength)
          end
        end

        # レスポンス
        {
          result: result,
          error:  errors
        }
      end
    end
  end
end