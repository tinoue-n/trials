module ValidationCheckHelper
  def validate_cards(cards)
    @error = {}
    if cards !~ /\A([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])\z/
      msgs = Array.new
      if cards.split.count != 5
        msg = MessageDefinition::NumberOfCards
        msgs << msg
      end
      if cards.match(/[^DHSC|0-9| ]/).present?
        msg = MessageDefinition::InvalidCharacter
        msgs << msg
      end
      if cards.match(/[DHSC][0]|[DHSC][1][4-9]|[DHSC][2-9][0-9]|[DHSC][0-9][0-9][0-9]/).present?
        msg = MessageDefinition::InvalidNumber
        msgs << msg
      end
      if cards.match(/[^\x01-\x7E]/).present?
        msg = MessageDefinition::EmCharacter
        msgs << msg
      end
      if cards.match(/[0-9][DHSC]/).present?
        msg = MessageDefinition::WithoutHalfSpace
        msgs << msg
      end
      if msg == nil
        msg = MessageDefinition::GeneralMessage
        msgs << msg
      end
      @error = {
        cards: cards,
        error: msgs
      }
    elsif cards.split.size != cards.split.uniq.size
      @error = {
        cards: cards,
        error: [MessageDefinition::DuplicatedCards]
      }
    end
    @error
  end
end