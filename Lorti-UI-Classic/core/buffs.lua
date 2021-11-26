local addon, ns = ...
local cfg = ns.cfg

local function durationSetText(duration, arg1, arg2)
	duration:SetText(format("|r"..string.gsub(arg1, " ", "").."|r", arg2))
end

	--backdrop debuff
	local backdropDebuff = {
		bgFile = nil,
		edgeFile = cfg.debuffFrame.background.edgeFile,
		tile = false,
		tileSize = 32,
		edgeSize = cfg.debuffFrame.background.inset,
    		insets = {
      			left = cfg.debuffFrame.background.inset,
      			right = cfg.debuffFrame.background.inset,
      			top = cfg.debuffFrame.background.inset,
      			bottom = cfg.debuffFrame.background.inset,
    		},
	}

	--backdrop buff
	local backdropBuff = {
		bgFile = nil,
		edgeFile = cfg.buffFrame.background.edgeFile,
		tile = false,
		tileSize = 32,
		edgeSize = cfg.buffFrame.background.inset,
		insets = {
			left = cfg.buffFrame.background.inset,
			right = cfg.buffFrame.background.inset,
			top = cfg.buffFrame.background.inset,
			bottom = cfg.buffFrame.background.inset,
		},
	}

  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

local function applySkin(b)
	if not b or (b and b.styled) then return end
	local name = b:GetName()
	local tempenchant, debuff, buff = false, false, false

	if (name:match("TempEnchant")) then
		tempenchant = true
	elseif (name:match("Debuff")) then
		debuff = true
	else
		buff = true
	end

	local cfg, backdrop
	if debuff then
		cfg = ns.cfg.debuffFrame
		backdrop = backdropDebuff
	else
		cfg = ns.cfg.buffFrame
		backdrop = backdropBuff
	end

	--button
--	b:SetSize(cfg.button.size, cfg.button.size)

    	--shadow
    	if cfg.background.show then
      		local back = CreateFrame("Frame", nil, b, BackdropTemplateMixin and "BackdropTemplate")
      		back:SetPoint("TOPLEFT", b, "TOPLEFT", 3, 3)
      		back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", cfg.background.padding, -cfg.background.padding)
      		back:SetFrameLevel(b:GetFrameLevel() - 1)
      		back:SetBackdrop(backdrop)
      		back:SetBackdropBorderColor(cfg.background.color.r,cfg.background.color.g,cfg.background.color.b,cfg.background.color.a)
      		b.bg = back
    	end

	--icon
	local icon = _G[name.."Icon"]
	icon:SetTexCoord(0.1,0.9,0.1,0.9)
	icon:ClearAllPoints()
    	icon:SetPoint("TOPLEFT", b, "TOPLEFT", -cfg.icon.padding, cfg.icon.padding)
    	icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", cfg.icon.padding, -cfg.icon.padding)
    	icon:SetDrawLayer("BACKGROUND",-8)
    	b.icon = icon

    	--border
	local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
	border:SetTexture(cfg.border.texture)
	border:SetTexCoord(0,1,0,1)
	border:SetDrawLayer("BACKGROUND",-7)

	if tempenchant then
		border:SetVertexColor(0.7,0,1)
	elseif not debuff then
		border:SetVertexColor(cfg.border.color.r,cfg.border.color.g,cfg.border.color.b)
	end

	border:ClearAllPoints()
	border:SetAllPoints(b)
	b.border = border

    	--duration
	b.duration:SetFont(cfg.duration.font, cfg.duration.size, "THINOUTLINE")
	b.duration:ClearAllPoints()
	b.duration:SetPoint(cfg.duration.pos.a1,cfg.duration.pos.x,cfg.duration.pos.y)
	hooksecurefunc(b.duration, "SetFormattedText", durationSetText)
    	--count
    	b.count:SetFont(cfg.count.font, cfg.count.size, "THINOUTLINE")
    	b.count:ClearAllPoints()
    	b.count:SetPoint(cfg.count.pos.a1,cfg.count.pos.x,cfg.count.pos.y)

    	--set button styled variable
    	b.styled = true
end

  ---------------------------------------
  -- INIT
  ---------------------------------------

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
	local button = _G['TempEnchant'..i]
	applySkin(button)
end

hooksecurefunc("AuraButton_Update", function(self, index)
		local button = _G[self..index]
		if (button and not button.styled) then applySkin(button) end
end)
