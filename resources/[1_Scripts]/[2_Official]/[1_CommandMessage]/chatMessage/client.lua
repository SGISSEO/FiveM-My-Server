AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    exports.chat:addMessage({
      color = {255, 0, 0},
      args = {"SYSTEM", string.format("%s has started.", resourceName)}
    })
  end)
  


  -- Note, the command has to start with `/`.
exports.chat:addSuggestion('/command', 'help text', {
    { name="paramName1", help="param description 1" },
    { name="paramName2", help="param description 2" }
})