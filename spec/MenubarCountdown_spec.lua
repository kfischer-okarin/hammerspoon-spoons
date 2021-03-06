buildFakeMacOs = require('spec.fake_mac_os')

MenubarCountdown = loadfile('MenubarCountdown.spoon/init.lua')()

describe('MenubarCountdown.spoon', function()
  before_each(function()
    _G.fakeMacOs = buildFakeMacOs()
    fakeMacOs:freezeTime()
  end)

  after_each(function()
    fakeMacOs:unfreezeTime()
  end)

  describe('Started Countdown', function()
    it('shows the countdown in the menubar', function()
      countdown = MenubarCountdown.new(
        'Countdown',
        os.time() + 60 * 60
      )
      countdown:start()

      countdownMenu = fakeMacOs:getMenu('Countdown: 1:00:00')
      assert.is_not_nil(countdownMenu)

      fakeMacOs:advanceTime(1)

      assert.is_equal(
        'Countdown: 59:59',
        countdownMenu.title
      )

      countdown:stop()

      menu = fakeMacOs:getMenu(countdownMenu.title)

      assert.is_nil(menu)

      fakeMacOs:advanceTime(1)

      assert.is_equal(
        'Countdown: 59:59',
        countdownMenu.title,
        'Countdown should not continue to run'
      )
    end)

    it('should show a negative time when the end time has passed', function()
      countdown = MenubarCountdown.new(
        'Countdown',
        os.time() + 60
      )
      countdown:start()

      countdownMenu = fakeMacOs:getMenu('Countdown: 1:00')
      assert.is_not_nil(countdownMenu)

      fakeMacOs:advanceTime(70)

      assert.is_equal(
        'Countdown: -0:10',
        countdownMenu.title
      )
    end)

    it('can execute a function when time runs out', function()
      local finished = false
      countdown = MenubarCountdown.new(
        'Countdown',
        os.time() + 10,
        {
          onFinish = function()
            finished = true
          end
        }
      )
      countdown:start()

      fakeMacOs:advanceTime(1)

      assert.is_false(finished)

      fakeMacOs:advanceTime(8)

      assert.is_false(finished)

      fakeMacOs:advanceTime(1)

      assert.is_true(finished)
    end)

    it('can execute a function when it is clicked', function()
      local clicked = false
      countdown = MenubarCountdown.new(
        'Countdown',
        os.time() + 10,
        {
          onClick = function()
            clicked = true
          end
        }
      )
      countdown:start()
      countdownMenu = fakeMacOs:getMenu('Countdown: 0:10')

      countdownMenu:leftClick()
    end)
  end)
end)
