include CheckCardsHelper
include ValidationCheckHelper
module Cards
  class API < Grape::API
    resource "check" do

      desc "役と最強フラグを返そう"

      params do
        requires :cards
      end

      post do

        # 前処理
        cards      = params[:cards].each_slice(1).to_a
        result     = Array.new
        @strengths = Array.new

        cards.each do |c|

          # パラメータ形式チェック
          validate(c.join)

          if @errors == []
            # 役を判定する
            check_cards(c.join)

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
            r.delete(:strength)
          else
            r[:best] = false
            r.delete(:strength)
          end
        end
        # レスポンス
        {
          result: result,
          error:  @errors
        }
      end
    end
  end
end
