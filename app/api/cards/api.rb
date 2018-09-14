module Cards
  class API < Grape::API
    resource "check" do

      desc "役と最強フラグを返そう"

      params do
        requires :cards
      end

      post do
        # 前処理
        cards = params[:cards].each_slice(1).to_a
        result = Array.new
        strengths = Array.new

        cards.each do |c|
          # ストレートの判定のためにパターン挙げる
          straight_patterns = [%w[1 2 3 4 5], %w[2 3 4 5 6], %w[3 4 5 6 7], %w[4 5 6 7 8], %w[5 6 7 8 9],
                               %w[6 7 8 9 10], %w[7 8 9 10 11], %w[8 9 10 11 12], %w[9 10 11 12 13], %w[10 11 12 13 1]]

          # スートと番号を配列に入れる
          suits   = c.to_s.gsub(/\d+/, "").split
          numbers = c.to_s.gsub(/[a-zA-Z]/, "").split.sort

          # フラッシュかどうかを判定
          if suits.uniq.size == 1
            # ストレートかどうかを判定
            if straight_patterns.include?(numbers)
              hand = "ストレートフラッシュ"
              strength = 9
            else
              hand = "フラッシュ"
              strength = 6
            end
          else
            # ストレートを先に判定
            if straight_patterns.include?(numbers)
              hand = "ストレート"
              strength = 5
            else
              # 同じ数字のカードの枚数を数えて配列にして役を判定する
              arr = numbers.uniq.map {|e| numbers.count(e)}.sort
              case arr
              when [1, 4]
                hand = "フォー・オブ・ア・カインド"
                strength = 8
              when [2, 3]
                hand = "フルハウス"
                strength = 7
              when [1, 1, 3]
                hand = "スリー・オブ・ア・カインド"
                strength = 4
              when [1, 2, 2]
                hand = "ツーペア"
                strength = 3
              when [1, 1, 1, 2]
                hand = "ワンペア"
                strength = 2
              when [1, 1, 1, 1, 1]
                hand = "ハイカード"
                strength = 1
              end
            end
          end

          # カードと判定した役をハッシュにして結果の配列に入れる
          r = {
            cards: c.join,
            hand: hand,
            strength: strength,
            best: nil
          }
          result << r
          strengths << strength
        end

        # 最強決定戦
        result.each do |r|
          if r[:strength] == strengths.max
            r[:best] = true
            r.delete(:strength)
          else
            r[:best] = false
            r.delete(:strength)
          end
        end
        
        # レスポンス
        {
          result: result
        }
      end
    end
  end
end