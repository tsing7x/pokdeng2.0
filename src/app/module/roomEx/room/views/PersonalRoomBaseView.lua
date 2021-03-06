
local RoomViewPosition = import("app.module.room.views.RoomViewPosition")

local PersonalRoomBaseView = class("PersonalRoomBaseView",function()
	return display.newNode()
end)


local TOP_BUTTOM_WIDTH   = 78
local TOP_BUTTOM_HEIGHT  = 58


function PersonalRoomBaseView:ctor(ctx)
	self.ctx = ctx

    self:setNodeEventEnabled(true)
    self:addDataObservers()

	self.backgroundImg_ = display.newSprite("room_background.png", display.cx, display.cy)
        :addTo(self)

    if display.width / display.height > 1140 / 640 then
        self.backgroundImg_:setScale(display.width / 1140)
    else
        self.backgroundImg_:setScale(display.height / 640)
    end

    if nk.config.CHRISTMAS_THEME_ENABLED then
        --todo

        local snowWindwPosShift = {
            x = 1,
            y = 1
        }

        local getSnowPosXYByRot = {
            [1] = function(snowWindwSpr)
                -- body

                return snowWindwSpr:getContentSize().width / 2 + snowWindwPosShift.x, snowWindwSpr:getContentSize().height / 2 + snowWindwPosShift.y
            end,

            [2] = function(snowWindwSpr)
                -- body

                return snowWindwSpr:getContentSize().width / 2 + snowWindwPosShift.x, display.height - snowWindwSpr:getContentSize().height / 2 - snowWindwPosShift.y
            end,

            [3] = function(snowWindwSpr)
                -- body
                return display.width - snowWindwSpr:getContentSize().width / 2 - snowWindwPosShift.x, display.height - snowWindwSpr:getContentSize().height / 2 - snowWindwPosShift.y
            end,

            [4] = function(snowWindwSpr)
                -- body
                return display.width - snowWindwSpr:getContentSize().width / 2 - snowWindwPosShift.x, snowWindwSpr:getContentSize().height / 2 + snowWindwPosShift.y
            end
        }

        self.chirstmasAmbNode_ = display.newNode()
            :addTo(self)

        for i = 1, 4 do
            local snowWindwEffect = display.newSprite("#christ_snowCorner_right.png")
                :rotation(90 * i)

            snowWindwEffect:pos(getSnowPosXYByRot[i](snowWindwEffect))
                :addTo(self.chirstmasAmbNode_)
        end
    end
    
    -- batchNode
    local batchNode = display.newBatchNode("room_texture.png"):addTo(self)

    --加入桌子
    local roomTableLeft = display.newSprite("#room_table.png")
    roomTableLeft:setAnchorPoint(cc.p(1, 0.5))
    roomTableLeft:pos(display.cx + 3, RoomViewPosition.SeatPosition[1].y - roomTableLeft:getContentSize().height * 0.5):addTo(batchNode)
    local roomTableRight = display.newSprite("#room_table.png")
    roomTableRight:setAnchorPoint(cc.p(1, 0.5))
    roomTableRight:setScaleX(-1)
    roomTableRight:pos(display.cx - 3, RoomViewPosition.SeatPosition[1].y - roomTableRight:getContentSize().height * 0.5):addTo(batchNode)

    --房间信息
    self.roomInfo_ = display.newTTFLabel({size=24, text="", color=cc.c3b(0x0, 0xB2, 0x3F)}):pos(display.cx, display.cy):addTo(self)

    local marginLeft = 32
    local marginTop = -30

    --菜单按钮
    self.topNode_ = display.newNode():pos(display.left + 8, display.top - 8):addTo(self)
    local menuPosX = marginLeft + 10
    local menuPosY = marginTop
    display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
        :pos(menuPosX, menuPosY)
        :addTo(self.topNode_)
    display.newSprite("#room_icon_menu.png")
        :pos(menuPosX, menuPosY)
        :addTo(self.topNode_)
    self.menuBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
        :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
        :onButtonClicked(buttontHandler(self, self.onMenuClick_))
        :pos(menuPosX, menuPosY)
        :addTo(self.topNode_)

    --站起按钮
    local standupPosX = marginLeft + 100
    local standupPosY = marginTop
    self.standupBtn_ = display.newNode():addTo(self.topNode_):hide()
    display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
        :pos(standupPosX, standupPosY)
        :addTo(self.standupBtn_)
    display.newSprite("#room_icon_standup.png")
        :pos(standupPosX, standupPosY)
        :addTo(self.standupBtn_)
    cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
        :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
        :onButtonClicked(buttontHandler(self, self.onStandupClick_))
        :pos(standupPosX, standupPosY)
        :addTo(self.standupBtn_)

    --换桌按钮

    --[[
    local changeRoomPosX = marginLeft + 100
    local changeRoomPosY = marginTop
    self.changeRoomBtn_ = display.newNode():addTo(self.topNode_):hide()
    display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
        :pos(changeRoomPosX, changeRoomPosY)
        :addTo(self.changeRoomBtn_)
    display.newSprite("#room_icon_change_room.png")
        :pos(changeRoomPosX, changeRoomPosY)
        :addTo(self.changeRoomBtn_)
    cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
        :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
        :onButtonClicked(buttontHandler(self, self.onChangeRoomClick_))
        :pos(changeRoomPosX, changeRoomPosY)
        :addTo(self.changeRoomBtn_)
--]]

    local isShowPay = nk.OnOff:check("payGuide")
    local isPay = nk.userData.best.paylog == 1 or false
    -- local isAlmChargeFavPay = nk.userData.bagPayList and nk.userData.bagPayList.almRechgFav == 1 or false

    --商城按钮
    local shopPosX = display.right - 56
    local shopPosY = marginTop

    if isShowPay and not isPay then
        --todo
        local firstChargeIconPath = nil

        if device.platform == "android" or device.platform == "windows" then
            --todo
            if nk.OnOff:check("firstchargeFavGray") then
                --todo
                firstChargeIconPath = "#chgFirFav_entry.png"
            else
                firstChargeIconPath = "#chargeFav_entry.png"
            end
        elseif device.platform == "ios" then
            --todo
            if nk.OnOff:check("firstchargeFavGray") then
                --todo
                firstChargeIconPath = "#chgFirFav_entry.png"
            else
                firstChargeIconPath = "#chargeFav_entry_ios.png"
            end
            -- firstChargeIconPath = "#chargeFav_entry_ios.png"
        end

        self._firstChargeEntryBtn = cc.ui.UIPushButton.new(firstChargeIconPath, {scale9 = false})
            :pos(shopPosX, shopPosY)
            :addTo(self.topNode_)
            :onButtonClicked(buttontHandler(self, self._onChargeFavCallBack))
    else
        local rechargeFavAccess = nk.userData.bagPayList and nk.userData.bagPayList.access == 1 or false
        if nk.OnOff:check("rechargeFavGray") and isShowPay and isPay and rechargeFavAccess then
            --todo
            local reChargeIconResKey = {}

            reChargeIconResKey[1] = "#chgAgnFav_entry_nor.png"  -- nor
            reChargeIconResKey[2] = "#chgAgnFav_entry_pre.png"  -- pre
            reChargeIconResKey[3] = "#chgAgnFav_entry_nor.png"  -- dis
            
            self._almRechargeEntryBtn = cc.ui.UIPushButton.new({normal = reChargeIconResKey[1], pressed = reChargeIconResKey[2],
                disabled = reChargeIconResKey[3]}, {scale9 = false})
                :onButtonClicked(buttontHandler(self, self.onAlmRechargeFavCallBack_))
                :pos(shopPosX, shopPosY)
                :addTo(self.topNode_)
        else

            if device.platform == "ios" and not isShowPay and isPay then
                --todo
                self._firstChargeEntryBtn = cc.ui.UIPushButton.new("#chargeFav_entry_ios.png", {scale9 = false})
                    :pos(shopPosX, shopPosY)
                    :addTo(self.topNode_)
                    :onButtonClicked(buttontHandler(self, self.onShopClick_))
            else

                display.newSprite("#room_ic_quickPay.png")
                    :pos(shopPosX, shopPosY)
                    :addTo(self.topNode_)

                local flagPosAdjust = {
                    x = 2,
                    y = 22
                }

                display.newSprite("#room_fg_quickPay.png")
                    :pos(shopPosX - flagPosAdjust.x, shopPosY - flagPosAdjust.y)
                    :addTo(self.topNode_)

                self._quickPayBtn = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png"--[[, pressed = "#rounded_rect_6.png"]]}, {scale9 = true})
                    :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
                    :onButtonClicked(buttontHandler(self, self.onShopClick_))
                    :pos(shopPosX, shopPosY)
                    :addTo(self.topNode_)
                
                self.shopOffBg_ = display.newSprite("#room_store_off_bg.png", self._quickPayBtn:getPositionX() - 16, self._quickPayBtn:getPositionY() + 8)
                    :addTo(self.topNode_)

                self.shopOffLabel_ = display.newTTFLabel({size=16, color=cc.c3b(0xFE, 0xF5, 0xD0), text=""})
                    :pos(self.shopOffBg_:getPositionX() - 6, self.shopOffBg_:getPositionY() + 6)
                    :rotation(-45)
                    :addTo(self.topNode_)

                self:setStoreDiscount()
            end
        end
        

        -- display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
        --     :pos(shopPosX, shopPosY)
        --     :addTo(self.topNode_)

        -- display.newSprite("#room_icon_store.png")
        --     :pos(shopPosX, shopPosY)
        --     :addTo(self.topNode_)

        -- self.shopBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
        --     :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
        --     :onButtonClicked(buttontHandler(self, self.onShopClick_))
        --     :pos(shopPosX, shopPosY)
        --     :addTo(self.topNode_)

        -- self.shopOffBg_ = display.newSprite("#room_store_off_bg.png", self.shopBtn_:getPositionX() - 16, self.shopBtn_:getPositionY() + 8)
        --     :addTo(self.topNode_)

        -- self.shopOffLabel_ = display.newTTFLabel({size=16, color=cc.c3b(0xFE, 0xF5, 0xD0), text=""})
        --     :pos(self.shopOffBg_:getPositionX() - 6, self.shopOffBg_:getPositionY() + 6)
        --     :rotation(-45)
        --     :addTo(self.topNode_)
    end

    --牌型按钮
    local cardTypePosX = marginLeft + 10
    local cardTypePosY = -display.height + 128
    display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
        :pos(cardTypePosX, cardTypePosY)
        :addTo(self.topNode_)
    display.newSprite("#room_icon_card_type.png")
        :pos(cardTypePosX, cardTypePosY)
        :addTo(self.topNode_)
    self.cardTypeBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
        :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
        :onButtonClicked(buttontHandler(self, self.onCardTypeClick_))
        :pos(cardTypePosX, cardTypePosY)
        :addTo(self.topNode_)


    --结算信息按钮

    --[[
    local calcBtnPosX = marginLeft + 10+TOP_BUTTOM_WIDTH*0.5+marginLeft+10
    local calcBtnPosY = -display.height + 128
    display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
        :pos(calcBtnPosX, calcBtnPosY)
        :addTo(self.topNode_)
    display.newSprite("room/personalRoom/calcBtn.png")
        :pos(calcBtnPosX, calcBtnPosY)
        :addTo(self.topNode_)
    self.calcBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
        :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
        :onButtonClicked(buttontHandler(self, self.onCalcBtnClick_))
        :pos(calcBtnPosX, calcBtnPosY)
        :addTo(self.topNode_)
    --]]

    --邀请按钮
    local inviteBtnPosX = display.right - 56 - TOP_BUTTOM_WIDTH-10
    local inviteBtnPosY = marginTop
    display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
        :pos(inviteBtnPosX, inviteBtnPosY)
        :addTo(self.topNode_)
    display.newSprite("#inviteBtn.png")
        :pos(inviteBtnPosX, inviteBtnPosY)
        :addTo(self.topNode_)
    self.inviteBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
        :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
        :onButtonClicked(buttontHandler(self, self.onInviteBtnClick_))
        :pos(inviteBtnPosX, inviteBtnPosY)
        :addTo(self.topNode_)



    self.toDealerSendChip_ = cc.ui.UIPushButton.new({normal="#room_dealer_send_chip_up.png", pressed="#room_dealer_send_chip_down.png"})
        :onButtonClicked(buttontHandler(self, self.toDelearSendChipHandler))
        :pos(display.cx - 68, -60)
        :addTo(self.topNode_)


    local isFirstSendDearlerChip = cc.UserDefault:getInstance():getBoolForKey(nk.cookieKeys.USER_FIRST_DEALER_SEND_CHIP .. nk.userData.uid, false)

    if  not isFirstSendDearlerChip then

        self.sendDealerChipIcon = display.newSprite("#room_dealer_send_chip_prompt_icon.png")
        self.sendDealerChipIcon:setScaleX(0.7)
        self.sendDealerChipIcon:setScaleY(0.7)
        self.sendDealerChipIcon:pos(display.cx - 68, -60)
        self.sendDealerChipIcon:addTo(self.topNode_)

    end

end

function PersonalRoomBaseView:addDataObservers()
    -- body
    self.onChargeFavOnOffObserver = bm.DataProxy:addDataObserver(nk.dataKeys.CHARGEFAV_ONOFF, handler(self, self.refreshFirstChargeFavEntryUi))
    self.onAlmRechargeFavOnOffObserver = bm.DataProxy:addDataObserver(nk.dataKeys.ALMRECHARGEFAV_ONOFF, handler(self, self.refreshAlmRechargeFavEntryUi))
end

function PersonalRoomBaseView:setStoreDiscount(discount)
    
    if self.shopOffBg_ == nil then
        --todo
        return
    end

    if discount and discount ~= 1 then
        self.shopOffBg_:show()
        self.shopOffLabel_:show()
        self.shopOffLabel_:setString(string.format("%+d%%", math.round((discount - 1) * 100)))
    else
        self.shopOffBg_:hide()
        self.shopOffLabel_:hide()
    end
end

function PersonalRoomBaseView:setRoomInfoText(roomInfo)
    
    local roomFiled = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_TITLE")
    local info = bm.LangUtil.getText("ROOM", "ROOM_INFO", roomFiled, roomInfo.tid, roomInfo.blind)
    self.roomInfo_:setString(info)
end

function PersonalRoomBaseView:setChangeRoomButtonMode(mode)
    if mode == 1 then
        -- self.changeRoomBtn_:show()
        self.standupBtn_:hide()
    else
        -- self.changeRoomBtn_:hide()
        self.standupBtn_:show()
    end
end

function PersonalRoomBaseView:refreshFirstChargeFavEntryUi(isOpen)
    -- body
    if not isOpen then
        --todo

        if self._firstChargeEntryBtn then
            --todo
            self._firstChargeEntryBtn:removeFromParent()
            self._firstChargeEntryBtn = nil

            -- 做出判断,绘制慈善礼包UI Below!--

            local isShowPay = nk.OnOff:check("payGuide")
            local isPay = nk.userData.best and nk.userData.best.paylog == 1 or false
            -- local isAlmChargeFavPay = nk.userData.bagPayList and nk.userData.bagPayList.almRechgFav == 1 or false

            local marginTop = - 30

            local shopPosX = display.right - 56
            local shopPosY = marginTop

            local rechargeFavAccess = nk.userData.bagPayList and nk.userData.bagPayList.access == 1 or false
            if nk.OnOff:check("rechargeFavGray") and isShowPay and isPay and rechargeFavAccess then
                --todo
                local reChargeIconResKey = {}

                reChargeIconResKey[1] = "#chgAgnFav_entry_nor.png"  -- nor
                reChargeIconResKey[2] = "#chgAgnFav_entry_pre.png"  -- pre
                reChargeIconResKey[3] = "#chgAgnFav_entry_nor.png"  -- dis
                
                self._almRechargeEntryBtn = cc.ui.UIPushButton.new({normal = reChargeIconResKey[1], pressed = reChargeIconResKey[2],
                    disabled = reChargeIconResKey[3]}, {scale9 = false})
                    :onButtonClicked(buttontHandler(self, self.onAlmRechargeFavCallBack_))
                    :pos(shopPosX, shopPosY)
                    :addTo(self.topNode_)
            else
                display.newSprite("#room_ic_quickPay.png")
                    :pos(shopPosX, shopPosY)
                    :addTo(self.topNode_)

                local flagPosAdjust = {
                    x = 2,
                    y = 22
                }

                display.newSprite("#room_fg_quickPay.png")
                    :pos(shopPosX - flagPosAdjust.x, shopPosY - flagPosAdjust.y)
                    :addTo(self.topNode_)

                self._quickPayBtn = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png"--[[, pressed = "#rounded_rect_6.png"]]}, {scale9 = true})
                    :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
                    :onButtonClicked(buttontHandler(self, self.onShopClick_))
                    :pos(shopPosX, shopPosY)
                    :addTo(self.topNode_)
                
                self.shopOffBg_ = display.newSprite("#room_store_off_bg.png", self._quickPayBtn:getPositionX() - 16, self._quickPayBtn:getPositionY() + 8)
                    :addTo(self.topNode_)

                self.shopOffLabel_ = display.newTTFLabel({size=16, color=cc.c3b(0xFE, 0xF5, 0xD0), text=""})
                    :pos(self.shopOffBg_:getPositionX() - 6, self.shopOffBg_:getPositionY() + 6)
                    :rotation(-45)
                    :addTo(self.topNode_)

                self:setStoreDiscount()
            end

            -- display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
            --     :pos(shopPosX, shopPosY)
            --     :addTo(self.topNode_)

            -- display.newSprite("#room_icon_store.png")
            --     :pos(shopPosX, shopPosY)
            --     :addTo(self.topNode_)

            -- self.shopBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
            --     :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
            --     :onButtonClicked(buttontHandler(self, self.onShopClick_))
            --     :pos(shopPosX, shopPosY)
            --     :addTo(self.topNode_)

            -- self.shopOffBg_ = display.newSprite("#room_store_off_bg.png", self.shopBtn_:getPositionX() - 16, self.shopBtn_:getPositionY() + 8)
            --     :addTo(self.topNode_)

            -- self.shopOffLabel_ = display.newTTFLabel({size=16, color=cc.c3b(0xFE, 0xF5, 0xD0), text=""})
            --     :pos(self.shopOffBg_:getPositionX() - 6, self.shopOffBg_:getPositionY() + 6)
            --     :rotation(-45)
            --     :addTo(self.topNode_)
        end
    end

end

function PersonalRoomBaseView:refreshAlmRechargeFavEntryUi(isOn)
    -- body
    if not isOn then
        --todo
        if self._almRechargeEntryBtn then
            --todo
            self._almRechargeEntryBtn:removeFromParent()
            self._almRechargeEntryBtn = nil

            local marginTop = - 30

            local shopPosX = display.right - 56
            local shopPosY = marginTop

            display.newSprite("#room_ic_quickPay.png")
                :pos(shopPosX, shopPosY)
                :addTo(self.topNode_)
                
            local flagPosAdjust = {
                x = 2,
                y = 22
            }

            display.newSprite("#room_fg_quickPay.png")
                :pos(shopPosX - flagPosAdjust.x, shopPosY - flagPosAdjust.y)
                :addTo(self.topNode_)

            self._quickPayBtn = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png"--[[, pressed = "#rounded_rect_6.png"]]}, {scale9 = true})
                :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
                :onButtonClicked(buttontHandler(self, self.onShopClick_))
                :pos(shopPosX, shopPosY)
                :addTo(self.topNode_)
            
            self.shopOffBg_ = display.newSprite("#room_store_off_bg.png", self._quickPayBtn:getPositionX() - 16, self._quickPayBtn:getPositionY() + 8)
                :addTo(self.topNode_)

            self.shopOffLabel_ = display.newTTFLabel({size=16, color=cc.c3b(0xFE, 0xF5, 0xD0), text=""})
                :pos(self.shopOffBg_:getPositionX() - 6, self.shopOffBg_:getPositionY() + 6)
                :rotation(-45)
                :addTo(self.topNode_)

            -- display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
            --     :pos(shopPosX, shopPosY)
            --     :addTo(self.topNode_)

            -- display.newSprite("#room_icon_store.png")
            --     :pos(shopPosX, shopPosY)
            --     :addTo(self.topNode_)

            -- self.shopBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
            --     :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
            --     :onButtonClicked(buttontHandler(self, self.onShopClick_))
            --     :pos(shopPosX, shopPosY)
            --     :addTo(self.topNode_)

            -- self.shopOffBg_ = display.newSprite("#room_store_off_bg.png", self.shopBtn_:getPositionX() - 16, self.shopBtn_:getPositionY() + 8)
            --     :addTo(self.topNode_)

            -- self.shopOffLabel_ = display.newTTFLabel({size=16, color=cc.c3b(0xFE, 0xF5, 0xD0), text=""})
            --     :pos(self.shopOffBg_:getPositionX() - 6, self.shopOffBg_:getPositionY() + 6)
            --     :rotation(-45)
            --     :addTo(self.topNode_)

            self:setStoreDiscount()
        end
    end
end

function PersonalRoomBaseView:onStandupClick_()
	if self. ctx.scene["onStandupClick_"] then
		self. ctx.scene:onStandupClick_()

	end
end

function PersonalRoomBaseView:onReviewClick_()
    if self.ctx.scene["onReviewClick_"] then
		self.ctx.scene:onReviewClick_()
	end
end

function PersonalRoomBaseView:onShopClick_()
    if self.ctx.scene["onShopClick_"] then
		self.ctx.scene:onShopClick_()
	end
end

function PersonalRoomBaseView:_onChargeFavCallBack()
    -- body
    if self.ctx.scene.onChargeFavClick_ then
        --todo
        self.ctx.scene:onChargeFavClick_()
    end
end

function PersonalRoomBaseView:onAlmRechargeFavCallBack_(evt)
    -- body
    if self.ctx.scene.onAlmRechargeFavClick_ then
        --todo
        self.ctx.scene:onAlmRechargeFavClick_()
    end
end

function PersonalRoomBaseView:onCalcBtnClick_()
    if self.ctx.scene["onCalcBtnClick_"] then
        self.ctx.scene:onCalcBtnClick_()
    end
end

function PersonalRoomBaseView:onInviteBtnClick_()
    if self.ctx.scene["onInviteBtnClick_"] then
        self.ctx.scene:onInviteBtnClick_()
    end
end

function PersonalRoomBaseView:onCardTypeClick_()
    if self.ctx.scene["onCardTypeClick_"] then
		self.ctx.scene:onCardTypeClick_()
	end
end

function PersonalRoomBaseView:onMenuClick_()
	if self.ctx.scene["onMenuClick_"] then
		self.ctx.scene:onMenuClick_()
	end
end

function PersonalRoomBaseView:onChangeRoomClick_()
	if self.ctx.scene["onChangeRoomClick_"] then
		self.ctx.scene:onChangeRoomClick_()
	end
end

function PersonalRoomBaseView:toDelearSendChipHandler()
	if self.ctx.scene["toDelearSendChipHandler"] then
		self.ctx.scene:toDelearSendChipHandler()
	end
end


function PersonalRoomBaseView:onCleanup()
    -- body

    bm.DataProxy:removeDataObserver(nk.dataKeys.CHARGEFAV_ONOFF, self.onChargeFavOnOffObserver)
    bm.DataProxy:removeDataObserver(nk.dataKeys.ALMRECHARGEFAV_ONOFF, self.onAlmRechargeFavOnOffObserver)
end

return PersonalRoomBaseView