addButtonSeperation = room_width/20

xDestinyButtonPos = room_width - room_width/5.2
yDestinyButtonPos = room_height - room_height/5

xStoryButtonPos = room_width - room_width/10.5
yStoryButtonPos = yDestinyButtonPos

xWealthButtonPos = room_width - room_width/3.24
yWealthButtonPos = yDestinyButtonPos

button = instance_create(xDestinyButtonPos, yDestinyButtonPos, oAddSubButton)
button.function = 0
button.owner = "destiny"

button = instance_create(xDestinyButtonPos + addButtonSeperation, yDestinyButtonPos, oAddSubButton)
button.function = 1
button.owner = "destiny"

button = instance_create(xStoryButtonPos, yStoryButtonPos, oAddSubButton)
button.function = 0
button.owner = "story"

button = instance_create(xStoryButtonPos + addButtonSeperation, yStoryButtonPos, oAddSubButton)
button.function = 1
button.owner = "story"

button = instance_create(xWealthButtonPos, yWealthButtonPos, oAddSubButton)
button.function = 0
button.owner = "wealth"

button = instance_create(xWealthButtonPos + addButtonSeperation, yWealthButtonPos, oAddSubButton)
button.function = 1
button.owner = "wealth"


