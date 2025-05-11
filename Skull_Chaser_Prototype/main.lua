local score
local timer
local pause
local running
local high_score = 0
local skull = {}
local mouse = {}
local SKULL_SIZE = 5
local SKULL_INIT_SPEED = 100

function print_to_center(text)
    love.graphics.printf(
        text, love.graphics.getWidth()/2,
        love.graphics.getHeight()/2,
        love.graphics.getFont():getWidth(text),
        "center", nil, nil, nil,
        love.graphics.getFont():getWidth(text)/2,
        love.graphics.getFont():getHeight())
end

function check_timer(dt)
    timer = timer + dt
    if timer >= .125 then
        timer = 0
        return true
    else
        return false
    end
end

function love.load()
    -- Initialize vars
    score = 0
    timer = 0
    pause = false
    running = true

    -- Set new cursor
    local brain = love.image.newImageData("images/PNG/Transparent/Icon14.png")
    local brain_cursor = love.mouse.newCursor(
        brain, brain:getWidth()/2, brain:getHeight()/2)
    love.mouse.setCursor(brain_cursor)

    -- Initialize skull
    skull.object = love.graphics.newImage("images/PNG/Transparent/Icon1.png")
    skull.x = love.graphics.getWidth()/2
    skull.y = love.graphics.getHeight()/2
    skull.speed = SKULL_INIT_SPEED
    skull.x_dir = SKULL_SIZE
    skull.min_len = math.min(skull.object:getWidth(), skull.object:getHeight()) * SKULL_SIZE / 2
end

function love.update(dt)
    -- Checking if user has lost
    mouse.x, mouse.y = love.mouse.getPosition()
    if math.sqrt((mouse.y - skull.y)^2 + (mouse.x - skull.x)^2) < skull.min_len then
        pause = true
        running = false
        if score > high_score then high_score = score end
    else
        -- Moving the skull
        skull.direction = math.atan2(mouse.y - skull.y, mouse.x - skull.x)
        skull.orientation = math.atan((mouse.y - skull.y) / (mouse.x - skull.x))
        if mouse.x < skull.x then skull.x_dir = -1 * SKULL_SIZE else skull.x_dir = SKULL_SIZE end
        if not pause then
            skull.x = skull.x + skull.speed * dt * math.cos(skull.direction)
            skull.y = skull.y + skull.speed * dt * math.sin(skull.direction)
        end
    end

    -- Incrementing the score
    if check_timer(dt) and not pause then score = score + 1 end
    skull.speed = SKULL_INIT_SPEED + score
end

function love.draw()
    love.graphics.print("SCORE: " .. score)
    love.graphics.print("\nHIGH SCORE: " .. high_score)
    love.graphics.draw(
        skull.object, skull.x, skull.y,
        skull.orientation, skull.x_dir, SKULL_SIZE,
        skull.object:getWidth()/2, skull.object:getHeight()/2)
    if not running then
        print_to_center("GAME OVER\nPress space to start over")
    end
end

function love.keypressed(key)
    if running and key == 'space' then pause = not pause end
    if not running and key == 'space' then love.load() end
end