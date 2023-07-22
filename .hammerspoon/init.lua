-- 键和应用对
-- 提示: 数字作为键，需要使用 [Number] 的格式
local KEY_APP_PAIRS = {
  I = "/System/Applications/Utilities/Terminal.app",
  S = "Safari.app",
  W = "WeChat.app",
  T = "Telegram.app",
  F = "/System/Library/CoreServices/Finder.app",
  [2] = "/Applications/SecTools/ida8.3/ida64.app",
  [3] = "QQ.app",
}

-- 显示 Finder: Alt + 1
hs.hotkey.bind({ "ctrl" }, "W", function()
  hs.application.open("/System/Library/CoreServices/Finder.app")
  hs.application.get("com.apple.finder"):setFrontmost(true)
end)

-- 重新加载配置
hs.hotkey.bind({ "cmd", "alt" }, "/", function()
  hs.reload()
end)


--------------------------------------------------------------------------------------
-- 按下 "Alt+键" 会打开或激活对应的应用，如果应用不是绝对路径，则指的是 /Applications 中的应用 --
--------------------------------------------------------------------------------------

function bindAppWithHotkey(keyAppPairs)

  for key, app in pairs(keyAppPairs) do
    -- local app = entry[2]
    -- local key = entry[1]

    -- 路径不以 / 开头，则指的是 /Applications 中的应用，把路径补充完整
    if string.sub(app, 0, 1) ~= "/" then
      app = "/Applications/" .. app
    end

    -- hs.alert.show(app)

    hs.hotkey.bind({ "alt" }, key .. "", function()
      app_name = get_app_name(app, "/")
      toggle_application_window(app_name, app)

    end)
  end
end

bindAppWithHotkey(KEY_APP_PAIRS)


-- 在app显示和隐藏之间切换
function toggle_application_window(_app_name, app_path)
  -- finds a running applications
  local app = hs.application.find(_app_name)
  -- application running, toggle hide/unhide
  if app then
    local mainwin = app:mainWindow()
    if mainwin then
      if true == app:isFrontmost() then
        app:hide()
      else
        app:activate(true)
        app:unhide()
        mainwin:focus()
      end
    else
      -- no windows, maybe hide
      if true == app:hide() then
        -- focus app
        hs.application.launchOrFocus(_app_name)
      else
        -- nothing to do
        hs.application.launchOrFocus(_app_name)
      end
    end
  else
    print("启动新app")
    hs.application.launchOrFocus(app_path)
  end
end

--------------------------------------------------------------------------------------
--                                        窗口管理                                   --
--------------------------------------------------------------------------------------
-- 窗口最大化
hs.hotkey.bind({ "shift", "cmd" }, "Return", function()
  moveAndResize("max")
end)

-- 窗口左半屏
hs.hotkey.bind({ "shift", "cmd" }, "H", function()
  moveAndResize("halfleft")
end)

-- 窗口右半屏
hs.hotkey.bind({ "shift", "cmd" }, "L", function()

  moveAndResize("halfright")
end)

-- 窗口靠左
hs.hotkey.bind({ "shift", "cmd" }, "J", function()
  moveAndResize("shrink")
end)

-- 窗口靠右
hs.hotkey.bind({ "shift", "cmd" }, "K", function()
  moveAndResize("expand")
end)

-- 窗口居中
hs.hotkey.bind({ "shift", "cmd" }, "I", function()
  moveAndResize("center")
end)

-- 窗口一半
hs.hotkey.bind({ "shift", "cmd" }, "U", function()

  moveAndResize("halfup")
end)
-- 创建下一半
hs.hotkey.bind({ "shift", "cmd" }, "O", function()

  moveAndResize("halfdown")
end)
-- 窗口死角
hs.hotkey.bind({ "shift", "cmd" }, ",", function()

  moveAndResize("cornerNW")
end)
hs.hotkey.bind({ "shift", "cmd" }, ";", function()

  moveAndResize("cornerNE")
end)
hs.hotkey.bind({ "shift", "cmd" }, "'", function()

  moveAndResize("cornerSW")
end)
hs.hotkey.bind({ "shift", "cmd" }, "/", function()

  moveAndResize("cornerSE")
end)



function moveAndResize(option)
  local cwin = hs.window.focusedWindow()
  if cwin then
    local gridparts = 30
    local cscreen = cwin:screen()
    local cres = cscreen:fullFrame()
    local stepw = cres.w / gridparts
    local steph = cres.h / gridparts
    local wf = cwin:frame()

    local cmax = cscreen:frame()

    if option == "halfleft" then
      cwin:setFrame({ x = cres.x, y = cres.y, w = cres.w / 2, h = cres.h })
    elseif option == "halfright" then
      cwin:setFrame({ x = cres.x + cres.w / 2, y = cres.y, w = cres.w / 2, h = cres.h })


      -- 定义  lesshalfleft、onethird、lesshalfright
    elseif option == "lesshalfleft" then
      cwin:setFrame({ x = cres.x, y = cres.y, w = cres.w / 3, h = cres.h })
    elseif option == "onethird" then
      cwin:setFrame({ x = cres.x + cres.w / 3, y = cres.y, w = cres.w / 3, h = cres.h })
    elseif option == "lesshalfright" then
      cwin:setFrame({ x = cres.x + cres.w / 3 * 2, y = cres.y, w = cres.w / 3, h = cres.h })

      -- 定义 mostleft、mostright
    elseif option == "mostleft" then
      cwin:setFrame({ x = cres.x, y = cres.y, w = cres.w / 3 * 2, h = cres.h })
    elseif option == "mostright" then
      cwin:setFrame({ x = cres.x + cres.w / 3, y = cres.y, w = cres.w / 3 * 2, h = cres.h })

      -- 定义 centermost
    elseif option == "centermost" then
      -- cwin:setFrame({x=cres.x+cres.w/3/2, y=cres.h/96, w=cres.w/3*2, h=cres.h})
      cwin:setFrame({ x = cres.x + cres.w / 3 / 2, y = cres.y, w = cres.w / 3 * 2, h = cres.h })

      -- 定义 show
      -- 宽度为24 分之 22
    elseif option == "show" then
      -- cwin:setFrame({x=cres.x+cres.w/3/2/2/2/2, y=cres.h/96, w=cres.w/48*46, h=cres.h})
      cwin:setFrame({ x = cres.x + cres.w / 3 / 2 / 2 / 2 / 2, y = cres.y, w = cres.w / 48 * 46, h = cres.h })

      -- 定义 shows
    elseif option == "shows" then
      -- cwin:setFrame({x=cres.x+cres.w/3/2/2, y=cres.h/96, w=cres.w/12*10, h=cres.h})
      cwin:setFrame({ x = cres.x + cres.w / 3 / 2 / 2, y = cres.y, w = cres.w / 12 * 10, h = cres.h })

      -- 定义 center-2
    elseif option == "center-2" then
      cwin:setFrame({ x = cres.x + cres.w / 2 / 2, y = cres.y, w = cres.w / 2, h = cres.h })

    elseif option == "halfup" then
      cwin:setFrame({ x = cres.x, y = cres.y, w = cres.w, h = cres.h / 2 })
    elseif option == "halfdown" then
      cwin:setFrame({ x = cres.x, y = cres.y + cres.h / 2, w = cres.w, h = cres.h / 2 })
    elseif option == "cornerNW" then
      cwin:setFrame({ x = cres.x, y = cres.y, w = cres.w / 2, h = cres.h / 2 })
    elseif option == "cornerNE" then
      cwin:setFrame({ x = cres.x + cres.w / 2, y = cres.y, w = cres.w / 2, h = cres.h / 2 })
    elseif option == "cornerSW" then
      cwin:setFrame({ x = cres.x, y = cres.y + cres.h / 2, w = cres.w / 2, h = cres.h / 2 })
    elseif option == "cornerSE" then
      cwin:setFrame({ x = cres.x + cres.w / 2, y = cres.y + cres.h / 2, w = cres.w / 2, h = cres.h / 2 })
    elseif option == "fullscreen" then
      cwin:setFrame({ x = cres.x, y = cres.y, w = cres.w, h = cres.h })
    elseif option == "center" then
      cwin:centerOnScreen()
      -- 窗口放大和缩小
    elseif option == "expand" then
      cwin:setFrame({ x = wf.x - stepw, y = wf.y - steph, w = wf.w + (stepw * 2), h = wf.h + (steph * 2) })
    elseif option == "shrink" then
      cwin:setFrame({ x = wf.x + stepw, y = wf.y + steph, w = wf.w - (stepw * 2), h = wf.h - (steph * 2) })
    elseif option == "max" then
      cwin:setFrame(cmax)
    end
  else
    hs.alert.show("No focused window!")
  end
end

--------------------------------------------------------------------------------------
--                                        多屏管理                                   --
--------------------------------------------------------------------------------------

-- 在屏幕间移动光标
hs.hotkey.bind({ "shift", "cmd" }, 'N', function()
  local screen = hs.mouse.getCurrentScreen()
  local nextScreen = screen:next()
  local rect = nextScreen:fullFrame()
  local center = hs.geometry.rectMidPoint(rect)

  hs.mouse.setAbsolutePosition(center)
end)

-- 在屏幕间移动程序
hs.hotkey.bind({ "shift", "cmd" }, 'M', function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  win:moveToScreen(screen:next(), 0)

  -- -- 移动到其他屏幕后应用的标题包含 "RDP-Windows" 则全屏
  -- if string.find(win:title(), "RDP-Windows", 1, true) then
  --     win:setFullScreen(true)
  -- end
end)

--------------------------------------------------------------------------------------
--                                        输入法切换                                  --
--------------------------------------------------------------------------------------
-- 双拼，自然码
function Input_Chinese_Shuangpin()
  hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.Shuangpin")
end

-- 英语
function Input_English()
  hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end
-- 俄语
function Input_Russian()
  hs.keycodes.currentSourceID("com.apple.keylayout.Russian")
end

hs.hotkey.bind({ "ctrl", "cmd" }, "P", function()
  Input_English()
  Input_Russian()
end)
hs.hotkey.bind({ "ctrl", "cmd" }, "I", function()
  Input_English()
end)
hs.hotkey.bind({ "ctrl", "cmd" }, "O", function()
  Input_English()
  Input_Chinese_Shuangpin()
end)

-- 获取指定的app的名字
function get_app_name(app, sep)
  t = string_split(app, sep)
  for _, v in ipairs(t) do
    -- print(v)
    if string.match(v, ".app") then
      name = string.gsub(v, ".app", "")
      return name
    end
  end
end

function string_split(name, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(name, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

-- 去掉字符串后面的空白字符
function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end


-- ui相关
local menubaritem = hs.menubar.new()
local menuData = {}

-- ipv4Interface ipv6 Interface
local interface = hs.network.primaryInterfaces()
-- 该对象用于存储全局变量，避免每次获取速度都创建新的局部变量
local obj = {}

function init()
  if interface then
    local interface_detail = hs.network.interfaceDetails(interface)
    if interface_detail.IPv4 then
      local ipv4 = interface_detail.IPv4.Addresses[1]
      table.insert(menuData, {
        title = "IPv4:" .. ipv4,
        tooltip = "Copy Ipv4 to clipboard",
        fn = function()
          hs.pasteboard.setContents(ipv4)
        end
      })
    end
    if interface_detail.IPv6 then
      for index, ip in ipairs(interface_detail.IPv6.Addresses) do
        table.insert(menuData, {
          title = "IPv6:" .. ip,
          tooltip = "Copy IPv6 to clipboard",
          fn = function()
            hs.pasteboard.setContents(ip)
          end
        })
      end
    end
    local mac = hs.execute('ifconfig ' .. interface .. ' | grep ether | awk \'{print $2}\'')
    table.insert(menuData, {
      title = 'MAC:' .. mac,
      tooltip = 'Copy MAC to clipboard',
      fn = function()
        hs.pasteboard.setContents(mac)
      end
    })
    obj.last_down = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $7}\'')
    obj.last_up = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $10}\'')
  else
    obj.last_down = 0
    obj.last_down = 0
  end

  -- 打开一些系统监控的程序
  table.insert(menuData, {
    title = '打开资源监控器',
    tooltip = 'Show Activity Monitor',
    fn = function()
      hs.application.launchOrFocus("/System/Applications/Utilities/Activity Monitor.app")
    end
  })
  table.insert(menuData, {
    title = '打开磁盘工具',
    tooltip = 'Show Disk Utility',
    fn = function()
      hs.application.launchOrFocus("/System/Applications/Utilities/Disk Utility.app")
    end
  })
  table.insert(menuData, {
    title = '打开Audio MIDI',
    tooltip = 'Show Audio MIDI',
    fn = function()
      hs.application.launchOrFocus("/System/Applications/Utilities/Audio MIDI Setup.app")
    end
  })
  menubaritem:setMenu(menuData)
end

function scan()
  -- print("3s 执行")
  if interface then
    -- print("3s 有网卡")
    obj.current_down = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $7}\'')
    obj.current_up = hs.execute('netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $10}\'')
  else
    -- print("3s 无网卡")
    obj.current_down = 0
    obj.current_up   = 0
    obj.last_down    = 0
    obj.last_up      = 0
  end

  obj.down_bytes = obj.current_down - obj.last_down
  obj.up_bytes = obj.current_up - obj.last_up

  obj.down_speed = format_speed(obj.down_bytes)
  obj.up_speed = format_speed(obj.up_bytes)

  obj.display_text = hs.styledtext.new('▲ ' .. obj.up_speed .. '\n' .. '▼ ' .. obj.down_speed,
    { font = { size = 9 }, color = { hex = '#FFFFFF' }, paragraphStyle = { alignment = "left", maximumLineHeight = 18 } })
  obj.last_down = obj.current_down
  obj.last_up = obj.current_up
  -- 如果要硬盘cpu内存的话，w =30+30+30+60
  local canvas = hs.canvas.new { x = 0, y = 0, h = 24, w = 60 }
  -- canvas[1] = {type = 'text', text = obj.display_text}
  canvas:appendElements(
    {
      type = "text",
      text = obj.display_text,
      -- withShadow = true,
      trackMouseEnterExit = true,
      frame = { x = 0, y = "0", h = "1", w = "1", }
    })
  menubaritem:setIcon(canvas:imageFromCanvas())
  canvas:delete()
  canvas = nil
end

function format_speed(bytes)
  -- 单位 Byte/s
  if bytes < 1024 then
    return string.format('%6.0f', bytes) .. ' B/s'
  else
    -- 单位 KB/s
    if bytes < 1048576 then
      -- 因为是每两秒刷新一次，所以要除以 （1024 * 2）
      return string.format('%6.1f', bytes / 2048) .. ' KB/s'
      -- 单位 MB/s
    else
      -- 除以 （1024 * 1024 * 2）
      return string.format('%6.1f', bytes / 2097152) .. ' MB/s'
    end
  end
end

local showNetworkSpeed = function()
  if (menuBarItem ~= nil and menuBarItem:isInMenuBar() == false) then
    return
  end
  if (menuBarItem == nil) then
    menuBarItem = hs.menubar.new()
  elseif (menuBarItem:isInMenuBar() == false) then
    menuBarItem:delete()
    menuBarItem = hs.menubar.new()
  end
  init()
  scan()
  if obj.timer then
    obj.timer:stop()
    obj.timer = nil
  end
  -- 三秒刷新一次
  obj.timer = hs.timer.doEvery(3, scan):start()
end

showNetworkSpeed()
