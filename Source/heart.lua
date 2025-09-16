local gfxit <const> = playdate.graphics.imagetable
local sprite <const> = playdate.graphics.sprite
local point <const> = playdate.geometry.point

class('Heart').extends(sprite)


---@param position_x number
---@param position_y number
function Heart.new(position_x, position_y)
  return Heart(position_x, position_y)
end


function Heart:initialize_animations()

    local heart_instance = self
    self.animations = {}

    local imagetable_mending_fixed = gfxit.new("images/ui_elements/heart_anims/broken_heart_fixed")
    local imagetable_breaking_heart = gfxit.new("images/ui_elements/heart_anims/heart_breaking")
    local imagetable_idle_broken = gfxit.new("images/ui_elements/heart_anims/heart_broken_idle")
    local imagetable_idle_full = gfxit.new("images/ui_elements/heart_anims/heart_full_idle")

    self.animations.heart_mending = AnimatedSprite.new(imagetable_mending_fixed)
    self.animations.heart_mending:addState(
            "main",
            1,
            imagetable_mending_fixed:getLength(),
            {
                tickStep = 30.0/8.0,
                loop = false,
                onAnimationEndEvent = function (self) self:setVisible(false) end
            }
        ).asDefault()

    self.animations.heart_breaking = AnimatedSprite.new(imagetable_breaking_heart)
    self.animations.heart_breaking:addState(
            "main",
            1,
            imagetable_breaking_heart:getLength(),
            {
                tickStep = 30.0/8.0,
                loop = false,
                onAnimationEndEvent = function (self) self:setVisible(false) end
            }
        ).asDefault()

    self.animations.heart_idle_broken = AnimatedSprite.new(imagetable_idle_broken)
    self.animations.heart_idle_broken:addState(
            "main",
            1,
            imagetable_idle_broken:getLength(),
            {
                tickStep = 30.0/2.0,
                loop = true,
            }
        ).asDefault()

    self.animations.heart_idle_full = AnimatedSprite.new(imagetable_idle_full)
    self.animations.heart_idle_full:addState(
            "main",
            1,
            imagetable_idle_full:getLength(),
            {
                tickStep = 30.0/2.0,
                loop = true,
            }
        ).asDefault()
end


---@param position_x number
---@param position_y number
function Heart:init(position_x, position_y)

    self:add()
    self:initialize_animations()

    for k, animation in pairs(self.animations) do
        self.animations[k]:moveTo(position_x, position_y)
    end

    self.animations.heart_idle_full:playAnimation()
    self.animations.heart_idle_full:setVisible(true)
    self.current_animation = self.animations.heart_idle_full

end


function Heart:break_heart()
    self.animations.heart_idle_full:setVisible(false)

    self.animations.heart_breaking:setVisible(true)
    self.animations.heart_breaking:playAnimation()
    self.current_animation = self.animations.heart_breaking
end


function Heart:mend_heart()
    self.animations.heart_idle_broken:setVisible(false)

    self.animations.heart_mending:setVisible(true)
    self.animations.heart_mending:playAnimation()
    self.current_animation = self.animations.heart_mending
end