--
-- Author: johnny@boomegg.com
-- Date: 2014-07-14 15:14:54
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
--

local MatchHandCard = class("MatchHandCard", function ()
    return display.newNode()
end)

-- 除了自己，其他座位上的牌默认scale = 0.8
function MatchHandCard:ctor(sizeScale)
    -- 设置缩放
    if sizeScale then self:setScale(sizeScale) end

    -- 扑克牌容器
    local PokerCard = nk.ui.PokerCard
    self.cards = {}
    self.cards[1] = PokerCard.new():pos(-24, 0):rotation(-12):addTo(self)
    self.cards[2] = PokerCard.new():pos(0, 0):rotation(0):addTo(self)
    self.cards[3] = PokerCard.new():pos(24, 0):rotation(12):addTo(self)

    self.cardNum_ = 3
end

-- 设置牌面
function MatchHandCard:setCards(cardsValue)
    --assert(type(cardsValue) == "table" and #cardsValue == 3, "cardsValue should be a table with length equals 3")
    for i, cardUint in ipairs(cardsValue) do
        self.cards[i]:setCard(cardUint)
    end
    return self
end

function MatchHandCard:setCardNum(cardNum)
    self.cardNum_ = cardNum
    assert(cardNum == 2 or cardNum == 3, "cardNum error " .. cardNum)
    if cardNum == 3 then
        self.cards[1]:moveTo(0.2, -24, 0):rotateTo(0.2, -12)
        self.cards[2]:moveTo(0.2, 0, 0):rotateTo(0.2, 0)
    else
        self.cards[1]:moveTo(0.2, -12, 0):rotateTo(0.2, -6)
        self.cards[2]:moveTo(0.2, 12, 0):rotateTo(0.2, 6)
        self.cards[3]:hide()
    end
end

function MatchHandCard:hideAllCards()
    for i = 1, 3 do
        self.cards[i]:hide()
    end
end

function MatchHandCard:showAllCards()
    for i = 1, self.cardNum_ do
        self.cards[i]:show()
    end
end

function MatchHandCard:shadowAllCards()
    -- body
    for i = 1, self.cardNum_ do
        self.cards[i]:addDark()
    end
end

-- 指定第几张牌翻牌
function MatchHandCard:flipWithIndex(...)
    local numArgs = select("#", ...)
    if numArgs >= 1 then
        for i = 1, numArgs do
            local value = select(i, ...)
            if value >= 1 and value <= self.cardNum_ then
                self.cards[value]:flip()
            end
        end
    end
    return self
end

function MatchHandCard:showWithIndex(...)
    local numArgs = select("#", ...)
    if numArgs >= 1 then
        for i = 1, numArgs do
            local value = select(i, ...)
            if value >= 1 and value <= self.cardNum_ then
                self.cards[value]:show()
            end
        end
    end
    return self
end

function MatchHandCard:isCardShow(idx)
    return self.cards[idx]:isVisible()
end

function MatchHandCard:isCardBack(idx)
    return self.cards[idx]:isBack()
end

function MatchHandCard:isCardFront(idx)
    return self.cards[idx]:isFront()
end

-- 翻开所有牌（比牌时）
function MatchHandCard:flipAll()
    for i = 1, self.cardNum_ do
        self.cards[i]:flip()
    end

    return self
end

function MatchHandCard:showFrontAll()
    for _, card in ipairs(self.cards) do
        card:showFront()
    end

    return self
end

function MatchHandCard:showBackAll()
    for _, card in ipairs(self.cards) do
        card:showBack()
    end

    return self
end

-- 震动牌：numCard = 2，前两张；numCard = 3，所有牌
function MatchHandCard:shakeWithNum(numCard)
    for i = 1, numCard do
        self.cards[i]:shake()
    end

    return self
end

function MatchHandCard:stopShakeAll()
    for _, card in ipairs(self.cards) do
        card:stopShake()
    end

    return self
end

-- 暗化牌：numCard = 2，前两张；numCard = 3，所有牌
function MatchHandCard:addDarkWithNum(numCard)
    for i = 1, numCard do
        self.cards[i]:addDark()
    end

    return self
end

function MatchHandCard:removeDarkAll()
    for _, card in ipairs(self.cards) do
        card:removeDark()
    end

    return self
end

function MatchHandCard:dispose()
    for _, card in ipairs(self.cards) do
        card:dispose()
    end
end

return MatchHandCard