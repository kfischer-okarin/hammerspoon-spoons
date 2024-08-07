local Slack = {
  name = 'Slack',
  version = '1.0',
  author = 'Kevin Fischer',
  license = 'MIT',
  homepage = 'https://github.com/kfischer-okarin/hammerspoon-spoons',
  settings = {
    uiTimeout = 0.3
  }
}

local function waitForUI()
  os.execute('sleep ' .. Slack.settings.uiTimeout)
end

local function pasteValue(value)
  originalClipboardContent = hs.pasteboard.getContents()
  hs.pasteboard.setContents(value)
  hs.eventtap.keyStroke({'cmd'}, 'V')
  hs.pasteboard.setContents(originalClipboardContent)
end

--- Slack.setStatus(message[, emote])
--- Function
--- Sets status on Slack.
---
--- Parameters:
---  * message - The status message to set
---  * emote - The emote to use (for example `:bento:`)
---
--- Returns:
---  * None
function Slack.setStatus(message, emote)
  if emote then
    Slack.sendSlackbotCommand('status ' .. emote .. ' ' .. message)
  else
    Slack.sendSlackbotCommand('status ' .. message)
  end
end

--- Slack.clearStatus()
--- Function
--- Clears status on Slack.
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function Slack.clearStatus()
  Slack.sendSlackbotCommand('clear status')
end

--- Slack.toggleAway()
--- Function
--- Toggles away status on Slack.
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function Slack.toggleAway()
  Slack.sendSlackbotCommand('away')
end

--- Slack.sendSlackbotCommand(command)
--- Function
--- Sends a command to Slackbot
---
--- Parameters:
---  * command - Command and arguments (without leading `/`)
---
--- Returns:
---  * None
function Slack.sendSlackbotCommand(command)
  Slack.sendMessageToChannel('Slackbot', '/' .. command)
end

--- Slack.sendMessageToChannel(command)
--- Function
--- Sends a message to a slack channel.
---
--- Parameters:
---  * channel - Channel name
---  * message - Message to send
---
--- Returns:
---  * None
function Slack.sendMessageToChannel(channel, message)
  Slack.openChannel(channel)
  pasteValue(message) -- to avoid completion dialogs
  hs.eventtap.keyStroke({}, 'return')
end

--- Slack.openChannel(command)
--- Function
--- Opens a slack channel.
---
--- Parameters:
---  * channel - Channel name
---
--- Returns:
---  * None
function Slack.openChannel(channel)
  Slack.focus()
  hs.eventtap.keyStroke({'cmd'}, 'K')
  waitForUI()
  hs.eventtap.keyStrokes(channel)
  waitForUI()
  hs.eventtap.keyStroke({}, 'return')
  waitForUI()
end

--- Slack.focus()
--- Function
--- Focuses Slack.
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function Slack.focus()
  hs.application.launchOrFocus('Slack')
  waitForUI()
end

return Slack
