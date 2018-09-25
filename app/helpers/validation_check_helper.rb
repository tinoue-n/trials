module ValidationCheckHelper
  def validate(c)
    @errors     = Array.new

    if c !~ /\A([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])( )([DHSC][1-9]|[DHSC][1][0-3])\z/
      msgs = Array.new
      if c.split.count != 5
        msg = "カードは5枚分入力してください"
        msgs << msg
      end
      if c.match(/[^DHSC|0-9| ]/).present?
        msg = "スート（DHSC）、数字、半角スペース以外の文字が含まれています"
        msgs << msg
      end
      if c.match(/[DHSC][0]|[DHSC][1][4-9]|[DHSC][2-9][0-9]/).present?
        msg = "カードの数字は1~13で入力してください"
        msgs << msg
      end
      if c.match(/[^\x01-\x7E]/).present?
        msg = "全角文字が含まれています"
        msgs << msg
      end
      if c.match(/[0-9][DHSC]/).present?
        msg = "カード同士は半角スペースで区切ってください"
        msgs << msg
      end
      if msg == nil
        msg = "カードのスートと数字を半角スペース区切りで5枚分入力してください"
        msgs << msg
      end
      error = {
        cards: c,
        error: msgs
      }
      @errors << error
    elsif c.split.size != c.split.uniq.size
      error = {
        cards: c,
        error: "カードが重複しています"
      }
      @errors << error
    end
  end
end