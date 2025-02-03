--!strict
local Text = {}

local Fonts = {
	Default = Font.fromId(12187371840,Enum.FontWeight.Medium,Enum.FontStyle.Normal),
	Bold = Font.fromId(12187371840,Enum.FontWeight.Medium,Enum.FontStyle.Normal)
}

local Sizes = {
    Regular = 10;
    Large = 20;
    Huge = 30;
}

Text.SetFont = function(label: TextLabel | TextBox | TextButton, font: string | nil)
    label.FontFace = Fonts[font] or Fonts.Default
end

Text.CreateLabel = function(parent: any, text: string, textSize: string, font: string, size: UDim2 | nil)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Text = text
    label.BackgroundTransparency = 1
    label.Size = size or UDim2.new(1, 0, 1, 0)
    if textSize == "Auto" then
        label.TextScaled = true
    else
        label.TextSize = Sizes[textSize] or Sizes.Regular
    end
    Text.SetFont(label, font)
end



return Text