
AuctionFixedPriceListItem = class("AuctionFixedPriceListItem",bm.ui.ListItem)

local ITEM_W = 863
local ITEM_H = 76


function AuctionFixedPriceListItem:ctor()
	AuctionFixedPriceListItem.super.ctor(self, ITEM_W, ITEM_H)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:setNodeEventEnabled(true)
	local bg = display.newSprite("#aucMar_bgListItem.png")
	:pos(ITEM_W/2,ITEM_H/2)
	:addTo(self)


	-- 商品图片
	local labelMarLeft,labelMarRight = 8,8
 	local labelCount = 7
 	local labelW = (ITEM_W - labelMarLeft - labelMarRight) / labelCount

 	self.iconWidth, self.iconHeight = 57, 57
	self.iconLoaderId_ = nk.ImageLoader:nextLoaderId() -- 头像加载id
	self.icon_ = display.newSprite("#aucMar_icProd.png")
    local iconSize = self.icon_:getContentSize()
    self.icon_:scale(self.iconWidth / iconSize.width)
        :align(display.CENTER_LEFT)
        :pos(labelMarLeft*5, ITEM_H/2)
        :addTo(self)

    self.numLabel_ = display.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER,color = cc.c3b(0xff,0xd3,0x00),dimensions = cc.size(labelW-3, ITEM_H)})
		:align(display.CENTER_LEFT)
		:pos( labelW  + labelMarLeft,ITEM_H/2)
		:addTo(self)


	-- self.auctorLabel_ = display.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER,color = cc.c3b(0xff,0xd3,0x00),dimensions = cc.size(labelW-3, 0)})
	-- 	:align(display.CENTER_LEFT)
	-- 	:pos( labelW * 2  + labelMarLeft,ITEM_H/2)
	-- 	:addTo(self)


	self.origAveragePriceLabel_ = display.newTTFLabel({text = "", size = 18, align = ui.TEXT_ALIGN_CENTER,color = cc.c3b(0x67,0xd8,0x32),dimensions = cc.size(labelW-3, ITEM_H)})
			:align(display.CENTER_LEFT)
			:pos( labelW * 2  + labelMarLeft,ITEM_H/2-13)
			:addTo(self)


	self.originalPriceLabel_ = display.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER,color = cc.c3b(0xff,0xd3,0x00),dimensions = cc.size(labelW-3, ITEM_H)})
		:align(display.CENTER_LEFT)
		:pos( labelW * 2  + labelMarLeft,ITEM_H/2+13)
		:addTo(self)


	display.newSprite("#main/auctionStatusBg_1.png")
	:align(display.CENTER_LEFT)
	:pos( labelW * 3  + labelMarLeft,ITEM_H/2)
	:addTo(self)

	self.currentPriceLabel_ = display.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER,color = cc.c3b(0xff,0xff,0xff),dimensions = cc.size(labelW-3, ITEM_H)})
		:align(display.CENTER_LEFT)
		:pos( labelW * 3  + labelMarLeft,ITEM_H/2)
		:addTo(self)



	self.timeLabel_ = display.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER,color = cc.c3b(0x67,0xd8,0x32),dimensions = cc.size(labelW-3, ITEM_H)})
		:align(display.CENTER_LEFT)
		:pos( labelW * 4  + labelMarLeft,ITEM_H/2)
		:addTo(self)


	self.bidderLabel_ = display.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER,color = cc.c3b(0xff,0xd3,0x00),dimensions = cc.size(labelW-4, ITEM_H)})
		:align(display.CENTER_LEFT)
		:pos( labelW * 5  + labelMarLeft,ITEM_H/2)
		:addTo(self)

	self.auctionBtnBg_ = display.newSprite("#main/auctionBtn.png")
    local bgsize = self.auctionBtnBg_:getContentSize()
    self.auctionBtnBg_
    :align(display.CENTER_LEFT)
    :pos( labelW * 6  + labelMarLeft+ 2,ITEM_H/2)
    :addTo(self)
    self.auctionBtn_ = cc.ui.UIPushButton.new({normal="#common_modTransparent.png", pressed="#common_button_pressed_cover.png"}, {scale9=true})
    self.auctionBtn_:setButtonSize(bgsize.width - 4, bgsize.height - 4)
    self.auctionBtn_:align(display.CENTER_LEFT)
    self.auctionBtn_:onButtonClicked(handler(self,self.onAuctionBtn))
    self.auctionBtn_:pos( labelW * 6  + labelMarLeft+ 2 ,ITEM_H/2)
    self.auctionBtn_:setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("AUCTION_MARKET", "AUCTION_NOW"),size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER}))
	self.auctionBtn_:addTo(self)


end


function AuctionFixedPriceListItem:onIconLoadComplete_(success, sprite)
    if success then
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()
        self.icon_:setTexture(tex)
        self.icon_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))
        self.icon_:setScaleX(self.iconWidth / texSize.width)
        self.icon_:setScaleY(self.iconHeight / texSize.height)
    end
end


function AuctionFixedPriceListItem:onDataSet(dataChanged, data)
	self.numLabel_:setString(data.num)
	-- self.auctorLabel_:setString(data.nick)
	self.originalPriceLabel_:setString(bm.formatBigNumber(data.money))
	self.currentPriceLabel_:setString(bm.LangUtil.getText("AUCTION_MARKET", "FIXED_PRICE")) 
	self.bidderLabel_:setString(data.aucter or "--")


	if data.num and data.num > 0 and data.money and data.money > 0 then
		local averPrice = bm.formatBigNumber(math.floor(data.money/data.num))
		self.origAveragePriceLabel_:setString(bm.LangUtil.getText("AUCTION_MARKET", "AVERAGE_PRICE",averPrice))
	else
		self.origAveragePriceLabel_:setString("")
	end


	nk.ImageLoader:loadAndCacheImage(
                self.iconLoaderId_, 
                data.imgurl or "", 
                handler(self, self.onIconLoadComplete_)
            )

	self.timeLabel_:setString("")
	local controller = self:getOwner().controller_
	if controller and controller["getNowTime"] then
		local nowTime = controller:getNowTime()
		if nowTime then
			local expire = data.expire
			local remainTime = expire - nowTime
			self.remainTime_ = remainTime
			self:showTime()
			self:countFun()
		end
	end
end


function AuctionFixedPriceListItem:countFun()
	
	if self.action_ then
        self:stopAction(self.action_)
    end

	if self.remainTime_ > 0 then
		self.action_ = self:schedule(function ()
            self.remainTime_ = self.remainTime_ - 1
            self:showTime()
        end, 1)
    else
    	self.timeLabel_:setString(bm.LangUtil.getText("AUCTION_MARKET", "EXPIRE_TIP"))  
	end
	  

end

function AuctionFixedPriceListItem:showTime() 
    timeStr = (self.remainTime_ > 0 and bm.TimeUtil:getTimeDayString(self.remainTime_)) or bm.LangUtil.getText("AUCTION_MARKET", "EXPIRE_TIP")
    if self.timeLabel_ then
        self.timeLabel_:setString(timeStr)
    end
    
end


function AuctionFixedPriceListItem:onAuctionBtn()
	self.data_.timeCount = self.remainTime_

	self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
end


function AuctionFixedPriceListItem:onCleanup()
    nk.ImageLoader:cancelJobByLoaderId(self.iconLoaderId_)
end


return AuctionFixedPriceListItem