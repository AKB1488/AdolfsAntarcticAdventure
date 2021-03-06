require 'busted'

local Terebi = require 'terebi'

local noop = function()
  return spy.new(function() end)
end

describe('Terebi:', function()
  before_each(function()
    _G.love = {
      graphics = {},
      mouse = {},
      window = {},
    }
    _G.love.graphics.newCanvas = spy.new(function(w, h)
      return {w, h}
    end)
    _G.love.window.getDesktopDimensions = spy.new(function()
      return 800, 600
    end)
    _G.love.window.getFullscreen = spy.new(function()
      return false
    end)
    _G.love.window.getMode = spy.new(function()
      return 640, 480, 'expected_mode'
    end)
  end)

  describe('When calling initializeLoveDefaults:', function()
    before_each(function()
      _G.love.graphics.setDefaultFilter = noop()
      _G.love.graphics.setLineStyle = noop()
      _G.love.mouse.setVisible = noop()
    end)

    it('It should call correct love2d methods.', function()
      Terebi.initializeLoveDefaults()

      assert.spy(love.graphics.setDefaultFilter).was.called_with('nearest', 'nearest')
      assert.spy(love.graphics.setLineStyle).was.called_with('rough')
      assert.spy(love.mouse.setVisible).was.called_with(false)
    end)
  end)

  describe('When creating a new Screen:', function()
    it('It should have correct default attributes', function()
      local screen = Terebi.newScreen(320, 240, 2)

      assert.spy(love.graphics.newCanvas).was.called_with(320, 240)

      assert.are.same(320, screen.width)
      assert.are.same(240, screen.height)
      assert.are.same({320, 240}, screen:getCanvas())
    end)
  end)
end)