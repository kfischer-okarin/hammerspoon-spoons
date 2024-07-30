buildFakeMacOs = require('spec.fake_mac_os')

Slack = loadfile('Slack.spoon/init.lua')()
Slack.settings.uiTimeout = 0

describe('Slack.spoon', function()
  before_each(function()
    _G.fakeMacOs = buildFakeMacOs()
  end)

  describe('.focus()', function()
    it('focuses Slack', function()
      Slack.focus()

      assert.are.equal(fakeMacOs:getApplication('Slack'), fakeMacOs.focusedApplication)
    end)
  end)

  describe('.openChannel()', function()
    it('focuses Slack and opens the correct channel', function()
      Slack.openChannel('general')

      slack = fakeMacOs:getApplication('Slack')
      assert.are.equal(slack, fakeMacOs.focusedApplication)
      assert.are.equal('general', slack.currentChannel)
    end)
  end)

  describe('.sendMessageToChannel()', function()
    it('opens the correct channel and sends message', function()
      Slack.sendMessageToChannel('general', 'Hello')

      slack = fakeMacOs:getApplication('Slack')
      assert.are.equal(slack, fakeMacOs.focusedApplication)
      assert.are.equal('general', slack.currentChannel)
      channel = slack:getChannel('general')
      assert.are.equal(1, #channel.messages)
      assert.are.equal('Hello', channel.messages[1])
    end)
  end)

  describe('.sendSlackbotCommand()', function()
    it('opens the Slackbot channel and sends the slash command', function()
      Slack.sendSlackbotCommand('remind me')

      slack = fakeMacOs:getApplication('Slack')
      assert.are.equal(slack, fakeMacOs.focusedApplication)
      assert.are.equal('Slackbot', slack.currentChannel)
      channel = slack:getChannel('Slackbot')
      assert.are.equal(1, #channel.messages)
      assert.are.equal('/remind me', channel.messages[1])
    end)
  end)

  describe('.toggleAway()', function()
    it('sends the /away command', function()
      Slack.toggleAway()

      slack = fakeMacOs:getApplication('Slack')
      assert.are.equal(slack, fakeMacOs.focusedApplication)
      assert.are.equal('Slackbot', slack.currentChannel)
      channel = slack:getChannel('Slackbot')
      assert.are.equal(1, #channel.messages)
      assert.are.equal('/away', channel.messages[1])
    end)
  end)

  describe('.setStatus()', function()
    it('can set a status without emote', function()
      Slack.setStatus('Lunch')

      slack = fakeMacOs:getApplication('Slack')
      assert.are.equal(slack, fakeMacOs.focusedApplication)
      assert.are.equal('Slackbot', slack.currentChannel)
      channel = slack:getChannel('Slackbot')
      assert.are.equal(1, #channel.messages)
      assert.are.equal('/status Lunch', channel.messages[1])
    end)

    it('can set a status with emote', function()
      Slack.setStatus('Lunch', ':bento:')

      slack = fakeMacOs:getApplication('Slack')
      assert.are.equal(slack, fakeMacOs.focusedApplication)
      assert.are.equal('Slackbot', slack.currentChannel)
      channel = slack:getChannel('Slackbot')
      assert.are.equal(1, #channel.messages)
      assert.are.equal('/status :bento: Lunch', channel.messages[1])
    end)
  end)

  describe('.clearStatus()', function()
    it('sends the /status command', function()
      Slack.clearStatus()

      slack = fakeMacOs:getApplication('Slack')
      assert.are.equal(slack, fakeMacOs.focusedApplication)
      assert.are.equal('Slackbot', slack.currentChannel)
      channel = slack:getChannel('Slackbot')
      assert.are.equal(1, #channel.messages)
      assert.are.equal('/clear status', channel.messages[1])
    end)
  end)
end)
