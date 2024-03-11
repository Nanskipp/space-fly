Client.OnStart = function()
    githubScriptsCount = 0
    loadGitHub()

    ui = require("uikit")
    loadingScreen.show()
    Camera:SetParent(nil)
end

Client.Tick = function(dt)
    deltaTime = 62/(1/dt)
    if githubScriptsCount == 2 then
        githubScriptsCount = nil
        loadingScreen:hide()
        start()
    elseif githubScriptsCount == nil then
        tick()
    end
end

-- load everything
loadGitHub = function()
    loadFromGitHub("https://raw.githubusercontent.com/Nanskipp/space-fly/main/scripts/start.lua",
    function(obj)
        start = obj -- set this as start function
        start()
    end)
    loadFromGitHub("https://raw.githubusercontent.com/Nanskipp/space-fly/main/scripts/tick.lua",
    function(obj)
        tick = obj -- set this as tick function
    end)
end

-- loading function
loadFromGitHub = function(url, callback)
    HTTP:Get(url, function(res)
        if res.StatusCode ~= 200 then
            print("Error on github loading. Code: " .. res.StatusCode)
            return
        end
        local obj = load(res.Body:ToString(), nil, "bt", _ENV)

        githubScriptsCount = githubScriptsCount + 1
        callback(obj)
        end)
end

loadingScreen = {}

loadingScreen.show = function()
    blackScreen = ui:createFrame(Color(0, 0, 0))

    blackScreen.Width = Screen.Width
    blackScreen.Height = Screen.Height

    loadingText = ui:createText("Loading: {placeholder}", Color(255, 255, 255))
    loadingText.Tick = function(self)
        self.pos.X = Screen.Width/2 - self.Width/2
        self.pos.Y = Screen.Height/2 - self.Height/2
    end
end

loadingScreen.hide = function(self)
    blackScreen:setParent(nil) blackScreen = nil
    loadingText:setParent(nil) loadingText.Tick = nil loadingText = nil
    self = nil
end