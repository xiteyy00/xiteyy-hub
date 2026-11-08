-- loader.lua
local Key = getgenv().xiteyy_Key
local GitHubUser = "xiteyy00"
local RepoName = "xiteyy-hub"

-- Links diretos para puxar os arquivos do seu GitHub
local API_URL = "https://raw.githubusercontent.com/" .. GitHubUser .. "/" .. RepoName .. "/main/key.txt"
local UI_URL = "https://raw.githubusercontent.com/" .. GitHubUser .. "/" .. RepoName .. "/main/ui.lua"

-- 1. Verifica se a Key é válida
local success, response = pcall(function()
    return game:HttpGet(API_URL)
end)

if not success then
    game.Players.LocalPlayer:Kick("Erro ao conectar com o servidor. Tente mais tarde.")
    return
end

local isValid = false
for validKey in string.gmatch(response, "[^\r\n]+") do
    if validKey == Key then
        isValid = true
        break
    end
end

if not isValid then
    game.Players.LocalPlayer:Kick("Key invalida! Compre uma nova no Discord.")
    return
end

-- 2. Se a Key for válida, baixa a interface e abre
local uiSuccess, uiCode = pcall(function()
    return game:HttpGet(UI_URL)
end)

if uiSuccess then
    loadstring(uiCode)()
else
    game.Players.LocalPlayer:Kick("Erro ao baixar a UI.")
end
