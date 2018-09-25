module ValidationCheckHelper
  def validate_cards(c)
    @error = {}
    if c !~ /\A([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])(\s)([DHSC][1-9]|[DHSC][1][0-3])\z/
      msgs = Array.new
      if c.split.count != 5
        msg = MessageDefinition::NumberOfCards
        msgs << msg
      end
      if c.match(/[^DHSC|0-9| ]/).present?
        msg = MessageDefinition::InvalidCharacter
        msgs << msg
      end
      if c.match(/[DHSC][0]|[DHSC][1][4-9]|[DHSC][2-9][0-9]/).present?
        msg = MessageDefinition::InvalidNumber
        msgs << msg
      end
      if c.match(/[^\x01-\x7E]/).present?
        msg = MessageDefinition::EmCharacter
        msgs << msg
      end
      if c.match(/[0-9][DHSC]/).present?
        msg = MessageDefinition::WithoutHalfSpace
        msgs << msg
      end
      if msg == nil
        msg = MessageDefinition::GeneralMessage
        msgs << msg
      end
      @error = {
        cards: c,
        error: msgs
      }
    elsif c.split.size != c.split.uniq.size
      @error = {
        cards: c,
        error: [MessageDefinition::DuplicatedCards]
      }
    end
    @error
  end
end