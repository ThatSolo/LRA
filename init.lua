--[[
    LRA.lua - Lazarus Raid Assignments

    ------------------------------------------------------------------------
    CREDITS
      Author:       Realist
      TurboSuite:   Drel        - https://github.com/drel-git/Turbo
                    (mini-bar/theming patterns in this script are matched
                    against Drel's real, shipped TurboSuite source)
      Idea from:    Angry Assignments (WoW addon)
                    - https://www.curseforge.com/wow/addons/angry-assignments
      Built with:   Claude (Anthropic)
    ------------------------------------------------------------------------

    A MacroQuest port of the WoW addon "Angry Assignments" idea, scoped to
    EverQuest kill orders / raid assignments:

      - You author named "pages" (freeform, line by line - kill order,
        tank swaps, interrupt rotation, whatever) in a control panel.
      - Hitting Send broadcasts that page over raid chat (group chat if
        you're not in a raid) to every character running this same script -
        including yourself. Receivers don't have to do anything; the page
        just appears.
      - The page shows up as a big, borderless banner (not a normal boxed
        window) that briefly flashes "UPDATED" so people notice it appear
        mid-fight, and can auto-hide while you're in combat.

    Written for MacroQuest's Lua engine (the same engine E3Next runs on top
    of), so it runs alongside E3Next rather than being an E3Next include.

    INSTALL
      Copy this whole folder to:  <MacroQuest folder>\lua\LRA\
      so you end up with:
        <MacroQuest folder>\lua\LRA\init.lua
        <MacroQuest folder>\lua\LRA\LRA_icon.png
      (this file is named init.lua once it's inside its own LRA\ folder -
      that's MacroQuest's own convention for a folder-based script, the
      same one Turbo/TurboSuite uses for itself: <folder>\init.lua run via
      "/lua run <folder>"). LRA_icon.png is the small badge icon used by
      the minimized mini bar (see DAILY USE below); LRA still works fine
      without it - it just falls back to a plain text button - but keep it
      alongside init.lua if you want the icon.
    RUN
      /lua run LRA

    (The slash command is "/lra" - if you have an old hotbutton bound to
    "/killorder" from before this renamed, update it to "/lra".)

    HOW THE BROADCAST WORKS (read this if it doesn't show up on other
    screens)
      There's no addon-message channel in EQ like WoW has, so this rides on
      ordinary raid/group chat: each Send breaks the page into a few chat
      lines wrapped in a distinctive "[KOA-...]" marker and says them over
      /rs (or /g if you're not in a raid). Every character with this script
      running is listening for that marker via a loose pattern match and
      reassembles it locally - so EVERY raider who wants to see your
      assignments needs this same script running (not just you). Because
      the exact wrapper text EQ puts around a raid-say line ("PlayerName
      says to raid, '...'" or similar) isn't something I could verify
      without a live game client, the listener pattern is deliberately
      loose (it looks for the [KOA-...] marker anywhere in the line, not
      the exact sentence around it). If it turns out not to catch on your
      client, run "/lra debug" - it prints every raw incoming chat
      line to the console so you can see the exact format your client
      uses; send me that and I'll tighten the pattern.

    DAILY USE
      - Type a page name and its lines into the "Lazarus Raid Assignments"
        control window, click "Save & Send".
      - Next raid, just click "Send" next to a saved page - no retyping.
      - The banner window can be dragged once to wherever you want it, then
        locked in place from the control window.
      - "- Minimize" in the top-left of the control window shrinks it down
        to a small floating mini bar; click that to bring the full panel
        back. This is a custom, separate mini window (the same pattern
        used by TurboSuite's "mini bar" for MacroQuest/EQEmu), not the
        window's built-in collapse arrow (which is disabled) - it can't
        get stuck the way that arrow could. If LRA_icon.png is sitting
        next to LRA.lua (see INSTALL), the mini bar shows a 48x48 gold-
        hexagon "LRA" badge icon in a gold-bordered, dark navy frame -
        sized and styled to match TurboGear's own standalone floating
        icon exactly (not the smaller icons on Turbo's main hub bar) -
        click the icon itself to restore. If that file is missing, or the
        running MacroQuest build doesn't support loading/drawing
        textures, it falls back automatically to the original small
        "LRA v" text button - either way, clicking it restores the full
        panel.

    KILL ORDER SECTION (Mark buttons)
      Below the freeform Lines editor is a separate "Kill Order" list: type
      an NPC's name on each row as your own written plan, then target that
      NPC yourself in-game (click, tab, /assist, extended target window -
      however you normally target) and click that row's "Mark N" button. It
      runs /rmarknpc N on whatever you currently have targeted - a local
      action on your own client (this does NOT get broadcast to anyone; the
      Lines/Send stuff above is still how you tell other raiders what the
      order is). The typed name is just your own reference for the plan;
      it's not used to target for you - name-based targeting (an earlier
      version of this tried /eqtarget <name>) wasn't reliable enough for
      this, so marking now always acts on your current target instead.
      The marker number matches the row's position in the list - row 1
      marks with 1, row 2 with 2, row 3 with 3 - since that's what "kill
      order" naturally means (1st/2nd/3rd priority target). EQ only has 3
      raid marker numbers, so a 4th+ row has no Mark button.
      /rmarknpc requires EverQuest's own "Mark NPC" raid privilege - the
      raid leader grants this from the raid window (right-most column of
      buttons next to a player's name; it's separate from Master/Client
      above, which only controls this script).

    LOOK & FEEL
      Buttons and section headers are color-coded by what they do (a color
      language borrowed from TurboSuite's own theme, adapted to this
      window): green for Save/Send, blue for Edit/New/the page editor,
      gold for Kill Order's Mark buttons, red for Delete, purple for the
      Banner settings, gray for Minimize/no-marker-left. Each section
      ("PAGE EDITOR", "KILL ORDER", "SAVED PAGES", "BANNER") gets a small
      colored dot next to its heading, and the Master/Client checkbox has
      one too (green when Master, gray when Client) - the same dot-marker
      look TurboSuite's own section headers use. Delete is drawn as a
      small circular "stop sign" icon instead of a plain button, mirroring
      a control TurboSuite draws the same way, and clicking it does NOT
      delete right away - it swaps that row to "Confirm delete" / "Cancel"
      buttons, and only clicking "Confirm delete" actually removes the
      page (arming a different row's delete, or clicking Cancel, backs out
      with nothing lost). All of this is purely cosmetic and defensively
      wrapped - a build that doesn't support the underlying draw-list
      calls just falls back to plain, uncolored widgets instead (a normal
      separator + white text, a plain red "X"
      button for Delete).

    MASTER / CLIENT ROLE
      This same file is what everyone in the raid runs - the "Raid Leader /
      Master" checkbox at the top of the control window is how each person
      decides, for themselves, whether they can author & send pages
      (Master) or just receive them (Client). It's a purely local, per-
      install setting (there's no way to control it remotely on someone
      else's machine) and is remembered across restarts. A Client's window
      hides the editor entirely and can't send, even via the optional
      "/lra send" command below. First time this runs with no
      settings saved yet, it defaults to Master if you already have saved
      pages (so upgrading doesn't change anything for whoever's been using
      it), or Client if you're starting completely fresh - so hand this
      file to raid members and they'll start out safely as Clients.

    OPTIONAL SLASH COMMANDS (handy for an EQ hotbutton; not required)
      /lra master on|off      - Raid Leader/Master vs. Client (receive only)
      /lra send <page name>   - broadcast a saved page (Master only)
      /lra show | hide        - toggle the banner
      /lra panel show|hide    - toggle the control window
      /lra announce on|off    - toggle broadcasting entirely (Master only)
      /lra debug on|off       - print every raw incoming chat line
      /lra exit               - unload the script
--]]

local mq = require('mq')

local SCRIPT_NAME    = 'LRA'
local PAGES_FILE     = 'LRA_pages.lua'
local OLD_PAGES_FILE = 'killorder_pages.lua'  -- pre-rename filename, for one-time migration
local SETTINGS_FILE  = 'LRA_settings.lua'
local INPUT_MAXLEN   = 256
local CODE_MAXLEN    = 8192   -- import/export page-code field; base64 runs bigger than raw text
local SEND_INTERVAL  = 0.4   -- avoid EQ chat throttling
local STALE_TIMEOUT  = 15
local FLASH_SECONDS  = 4
local MAX_LINE_LEN   = 200   -- soft cap; longer lines just get a console warning, not truncated

-- Manual-resize font scaling is relative to this reference size (the
-- window's default open size, below) and clamped to MIN/MAX_SCALE.
local BANNER_BASE_W    = 420
local BANNER_BASE_H    = 220
local BANNER_MIN_SCALE = 0.6
local BANNER_MAX_SCALE = 5.0

math.randomseed(os.time() + math.floor(os.clock() * 1000))

local RUNNING = true

local state = {
    pages        = {},     -- array of { name = str, lines = { str, ... }, killOrder = { str, ... } }
    editName     = '',
    editLines    = { '' },
    editKillOrder = { '' },
    editingIndex = nil,

    isMaster     = true,   -- placeholder; real default is set once by loadSettingsFromDisk()
    announce     = true,
    debug        = false,
    controlOpen  = true,
    controlMinimized = false,  -- true = shrunk to the mini bar (its own separate window)
    bannerShow   = true,
    combatHide   = false,
    lockPosition = false,
    autoSize     = true,
    fontScale    = 1.6,

    activeNote   = nil,   -- { pageName = str, lines = {...}, receivedAt = os.clock() }
    incoming     = {},    -- [txid] = { namesafe=, linecount=, lines={ {seq=,text=} }, lastSeen= }

    pendingDeleteIndex = nil,  -- Saved Pages row awaiting Confirm/Cancel after its stop-sign was clicked; nil = no row is mid-confirm

    importText   = '',   -- Import Page Code text field
    exportText   = nil,  -- last-exported page code, shown so it can be copied even without clipboard access

    sendQueue    = {},
    lastSendAt   = 0,
}

--------------------------------------------------------------------------
-- small helpers
--------------------------------------------------------------------------

local function trim(s)
    return (s:gsub('^%s*(.-)%s*$', '%1'))
end

local function inRaid()
    local ok, members = pcall(function()
        return mq.TLO.Raid.Members()
    end)
    return ok and type(members) == 'number' and members > 0
end

local function sanitizeForWire(text)
    -- avoid breaking the [KOA-...] bracket-delimited wire protocol on a stray ']'
    text = text:gsub('%]', ')')
    if #text > MAX_LINE_LEN then
        print(string.format(
            '[LRA] warning: a line is %d characters - consider shortening it (chat may truncate long lines).',
            #text))
    end
    return text
end

local function newTxId()
    return string.format('%x%x', os.time() % 0xFFFF, math.random(0, 0xFFFF))
end

--------------------------------------------------------------------------
-- persistence (mq.pickle)
--------------------------------------------------------------------------

local function loadPagesFromDisk()
    local chunk = loadfile(mq.configDir .. '/' .. PAGES_FILE)
    if chunk then
        local ok, data = pcall(chunk)
        if ok and type(data) == 'table' then
            state.pages = data
            return
        end
    end

    -- one-time migration from the pre-rename killorder_pages.lua, if that's all that exists
    local oldChunk = loadfile(mq.configDir .. '/' .. OLD_PAGES_FILE)
    if oldChunk then
        local ok, data = pcall(oldChunk)
        if ok and type(data) == 'table' then
            state.pages = data
            mq.pickle(PAGES_FILE, state.pages)
            print(string.format('[LRA] migrated %d saved page(s) from %s to %s.', #state.pages, OLD_PAGES_FILE, PAGES_FILE))
        end
    end
end

local function savePagesToDisk()
    mq.pickle(PAGES_FILE, state.pages)
end

local function loadSettingsFromDisk()
    local chunk = loadfile(mq.configDir .. '/' .. SETTINGS_FILE)
    if chunk then
        local ok, data = pcall(chunk)
        if ok and type(data) == 'table' and type(data.isMaster) == 'boolean' then
            state.isMaster = data.isMaster
            return
        end
    end
    -- first run: default to Master only if pages already exist (upgrade), else safer Client
    state.isMaster = (#state.pages > 0)
    mq.pickle(SETTINGS_FILE, { isMaster = state.isMaster })
end

local function saveSettingsToDisk()
    mq.pickle(SETTINGS_FILE, { isMaster = state.isMaster })
end

local function findPageIndexByName(name)
    for i, p in ipairs(state.pages) do
        if p.name == name then
            return i
        end
    end
    return nil
end

--------------------------------------------------------------------------
-- outbound: queued and drained a line at a time in the main loop, so we
-- never block the UI thread or spam chat faster than EQ likes
--------------------------------------------------------------------------

local function queueSend(name, lines)
    if not state.isMaster then
        print('[LRA] this client is in Client mode - enable "Raid Leader / Master" to send.')
        return
    end
    if not state.announce then
        print('[LRA] broadcasting is OFF - enable it to send.')
        return
    end
    local txid = newTxId()
    local namesafe = name:gsub('%s+', '_')
    table.insert(state.sendQueue, string.format('[KOA-BEGIN %s %s %d]', txid, namesafe, #lines))
    for i, line in ipairs(lines) do
        table.insert(state.sendQueue, string.format('[KOA-L %s %d %s]', txid, i, sanitizeForWire(line)))
    end
    table.insert(state.sendQueue, string.format('[KOA-END %s]', txid))
end

local function pumpSendQueue()
    if #state.sendQueue == 0 then
        return
    end
    local now = os.clock()
    if now - state.lastSendAt < SEND_INTERVAL then
        return
    end
    local msg = table.remove(state.sendQueue, 1)
    if inRaid() then
        mq.cmdf('/rs %s', msg)
    else
        mq.cmdf('/g %s', msg)
    end
    state.lastSendAt = now
end

--------------------------------------------------------------------------
-- kill order: "Mark #" buttons - local only, never broadcast. Acts on
-- whatever is currently targeted in-game rather than the row's typed name
-- (name-based /eqtarget wasn't reliable enough - duplicate/partial matches).
--------------------------------------------------------------------------

local function markCurrentTarget(markerNum)
    local hasTarget, targetName = false, nil
    pcall(function()
        local id = mq.TLO.Target.ID()
        if id and id > 0 then
            hasTarget = true
            targetName = mq.TLO.Target.CleanName() or mq.TLO.Target.Name()
        end
    end)
    if not hasTarget then
        print('[LRA] nothing targeted - target the NPC in-game first, then click Mark ' .. markerNum .. '.')
        return
    end
    mq.cmdf('/rmarknpc %d', markerNum)
    print(string.format('[LRA] marked %s with raid marker %d.', targetName or '(current target)', markerNum))
end

--------------------------------------------------------------------------
-- page CRUD (driven by the control window's text boxes / buttons)
--------------------------------------------------------------------------

local function beginNewPage()
    state.editName = ''
    state.editLines = { '' }
    state.editKillOrder = { '' }
    state.editingIndex = nil
end

local function beginEditPage(index)
    local p = state.pages[index]
    if not p then
        return
    end
    state.editName = p.name
    state.editLines = {}
    for _, l in ipairs(p.lines) do
        table.insert(state.editLines, l)
    end
    if #state.editLines == 0 then
        state.editLines = { '' }
    end
    state.editKillOrder = {}
    for _, k in ipairs(p.killOrder or {}) do
        table.insert(state.editKillOrder, k)
    end
    if #state.editKillOrder == 0 then
        state.editKillOrder = { '' }
    end
    state.editingIndex = index
end

local function collectEditLines()
    local lines = {}
    for _, l in ipairs(state.editLines) do
        local t = trim(l)
        if t ~= '' then
            table.insert(lines, t)
        end
    end
    return lines
end

local function collectEditKillOrder()
    local names = {}
    for _, k in ipairs(state.editKillOrder) do
        local t = trim(k)
        if t ~= '' then
            table.insert(names, t)
        end
    end
    return names
end

local function savePage(alsoSend)
    local name = trim(state.editName)
    local lines = collectEditLines()
    local killOrder = collectEditKillOrder()

    if name == '' then
        print('[LRA] enter a page name before saving.')
        return
    end
    if #lines == 0 then
        print('[LRA] enter at least one line before saving.')
        return
    end

    local idx = findPageIndexByName(name)
    if idx then
        state.pages[idx].lines = lines
        state.pages[idx].killOrder = killOrder
    else
        table.insert(state.pages, { name = name, lines = lines, killOrder = killOrder })
        idx = #state.pages
    end

    savePagesToDisk()
    state.editingIndex = idx
    print(string.format('[LRA] saved page "%s" (%d line(s)).', name, #lines))

    if alsoSend then
        queueSend(name, lines)
    end
end

local function deletePage(index)
    local p = state.pages[index]
    if not p then
        return
    end
    table.remove(state.pages, index)
    savePagesToDisk()
    if state.editingIndex == index then
        beginNewPage()
    end
    print(string.format('[LRA] deleted page "%s".', p.name))
end

-- Remaps a tracked row index after src moved to dst (table.remove+insert
-- semantics), so an in-progress edit or delete-confirm keeps following the
-- same page across a drag-reorder instead of silently landing on whatever
-- page ended up at that old index.
local function remapIndexAfterMove(idx, src, dst)
    if not idx then
        return idx
    end
    if idx == src then
        return dst
    end
    if src < dst then
        if idx > src and idx <= dst then
            return idx - 1
        end
    else
        if idx >= dst and idx < src then
            return idx + 1
        end
    end
    return idx
end

local function movePage(src, dst)
    src = tonumber(src)
    dst = tonumber(dst)
    if not src or not dst or src == dst or src < 1 or dst < 1
        or src > #state.pages or dst > #state.pages then
        return
    end
    local p = table.remove(state.pages, src)
    table.insert(state.pages, dst, p)
    state.editingIndex = remapIndexAfterMove(state.editingIndex, src, dst)
    state.pendingDeleteIndex = remapIndexAfterMove(state.pendingDeleteIndex, src, dst)
    savePagesToDisk()
end

--------------------------------------------------------------------------
-- sharing: a saved page as a single copy-pasteable text code (Export on a
-- Saved Pages row, Import Page Code in the editor), for handing pages to
-- people over Discord/forums rather than only live in-raid broadcast. Pure
-- Lua base64 - no external library to depend on for a distributed script.
--------------------------------------------------------------------------

local B64_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local B64_LOOKUP = {}
for i = 1, #B64_CHARS do
    B64_LOOKUP[B64_CHARS:sub(i, i)] = i - 1
end

local function base64Encode(data)
    local out = {}
    local len = #data
    for i = 1, len, 3 do
        local b1, b2, b3 = data:byte(i, i + 2)
        local chunkLen = math.min(3, len - i + 1)
        local n = b1 * 0x10000 + (b2 or 0) * 0x100 + (b3 or 0)
        local i1 = math.floor(n / 0x40000) % 0x40 + 1
        local i2 = math.floor(n / 0x1000) % 0x40 + 1
        local i3 = math.floor(n / 0x40) % 0x40 + 1
        local i4 = n % 0x40 + 1
        out[#out + 1] = B64_CHARS:sub(i1, i1) .. B64_CHARS:sub(i2, i2)
            .. (chunkLen >= 2 and B64_CHARS:sub(i3, i3) or '=')
            .. (chunkLen >= 3 and B64_CHARS:sub(i4, i4) or '=')
    end
    return table.concat(out)
end

local function base64Decode(str)
    str = str:gsub('[^%w+/=]', '')  -- drop whitespace/newlines picked up from copy-paste
    local out = {}
    local i, len = 1, #str
    while i <= len do
        local c1, c2 = B64_LOOKUP[str:sub(i, i)], B64_LOOKUP[str:sub(i + 1, i + 1)]
        if not c1 or not c2 then
            return nil  -- malformed - not our own export string
        end
        local c3ch, c4ch = str:sub(i + 2, i + 2), str:sub(i + 3, i + 3)
        local c3 = (c3ch ~= '' and c3ch ~= '=') and B64_LOOKUP[c3ch] or nil
        local c4 = (c4ch ~= '' and c4ch ~= '=') and B64_LOOKUP[c4ch] or nil
        local n = c1 * 0x40000 + c2 * 0x1000 + (c3 or 0) * 0x40 + (c4 or 0)
        out[#out + 1] = string.char(math.floor(n / 0x10000) % 0x100)
        if c3 then out[#out + 1] = string.char(math.floor(n / 0x100) % 0x100) end
        if c4 then out[#out + 1] = string.char(n % 0x100) end
        i = i + 4
    end
    return table.concat(out)
end

local EXPORT_PREFIX = 'LRA1:'
local FIELD_SEP = string.char(2)  -- separates name / lines-block / killOrder-block
local LINE_SEP  = string.char(1)  -- separates entries within a lines/killOrder block

local function splitBySep(s, sep)
    if s == '' then
        return {}
    end
    local out = {}
    for part in (s .. sep):gmatch('(.-)' .. sep) do
        table.insert(out, part)
    end
    return out
end

local function exportPageToString(p)
    local blob = p.name .. FIELD_SEP
        .. table.concat(p.lines or {}, LINE_SEP) .. FIELD_SEP
        .. table.concat(p.killOrder or {}, LINE_SEP)
    return EXPORT_PREFIX .. base64Encode(blob)
end

-- Parses a pasted page code back into { name, lines, killOrder }. Never
-- errors on bad input - this is text a person pasted in from outside the
-- game - it just returns nil plus a reason.
local function importStringToPage(str)
    str = trim(str or '')
    if str:sub(1, #EXPORT_PREFIX) ~= EXPORT_PREFIX then
        return nil, 'not an LRA page code (missing "LRA1:" prefix)'
    end
    local blob = base64Decode(str:sub(#EXPORT_PREFIX + 1))
    if not blob then
        return nil, 'corrupted page code (invalid characters)'
    end
    local fields = splitBySep(blob, FIELD_SEP)
    local name = fields[1] or ''
    local lines = splitBySep(fields[2] or '', LINE_SEP)
    local killOrder = splitBySep(fields[3] or '', LINE_SEP)
    if trim(name) == '' or #lines == 0 then
        return nil, 'corrupted page code (missing name or lines)'
    end
    return { name = name, lines = lines, killOrder = killOrder }
end

local function sendPageByIndex(index)
    local p = state.pages[index]
    if not p then
        return
    end
    queueSend(p.name, p.lines)
end

local function sendPageByName(name)
    local idx = findPageIndexByName(name)
    if not idx then
        print(string.format('[LRA] no saved page named "%s"', name))
        return
    end
    sendPageByIndex(idx)
end

--------------------------------------------------------------------------
-- inbound: reassemble a broadcast (from anyone, including yourself) into
-- the active banner
--------------------------------------------------------------------------

local function pruneStaleIncoming()
    local now = os.clock()
    for txid, buf in pairs(state.incoming) do
        if now - buf.lastSeen > STALE_TIMEOUT then
            state.incoming[txid] = nil
        end
    end
end

local function onRawLine(line)
    if state.debug then
        print('[LRA debug] ' .. tostring(line))
    end
end

local function onBegin(line, txid, namesafe, linecountStr)
    onRawLine(line)
    state.incoming[txid] = {
        namesafe  = namesafe,
        linecount = tonumber(linecountStr) or 0,
        lines     = {},
        lastSeen  = os.clock(),
    }
end

local function onLine(line, txid, seqStr, text)
    onRawLine(line)
    local buf = state.incoming[txid]
    if not buf then
        -- BEGIN was missed (dropped chat line, script started mid-send,
        -- etc). Start a buffer anyway so we can still assemble what we get.
        buf = { namesafe = '?', linecount = 0, lines = {}, lastSeen = os.clock() }
        state.incoming[txid] = buf
    end
    table.insert(buf.lines, { seq = tonumber(seqStr) or 0, text = text })
    buf.lastSeen = os.clock()
end

local function onEnd(line, txid)
    onRawLine(line)
    local buf = state.incoming[txid]
    if not buf then
        return
    end
    table.sort(buf.lines, function(a, b) return a.seq < b.seq end)
    local ordered = {}
    for _, entry in ipairs(buf.lines) do
        table.insert(ordered, entry.text)
    end
    state.activeNote = {
        pageName   = (buf.namesafe or '?'):gsub('_', ' '),
        lines      = ordered,
        receivedAt = os.clock(),
    }
    state.incoming[txid] = nil
end

-- leading/trailing #*# deliberately loose, to absorb whatever wrapper text
-- EQ puts around a raid/group-say line (unconfirmed without a live client -
-- see the file header's "/lra debug" note)
mq.event('killorder_begin', '#*#[KOA-BEGIN #1# #2# #3#]#*#', onBegin)
mq.event('killorder_line',  '#*#[KOA-L #1# #2# #3#]#*#',     onLine)
mq.event('killorder_end',   '#*#[KOA-END #1#]#*#',           onEnd)

--------------------------------------------------------------------------
-- slash command (optional - handy for EQ hotbuttons, not required)
--------------------------------------------------------------------------

local function printHelp()
    print('[LRA] optional commands (the window handles daily use):')
    print('  /lra master on|off     - Raid Leader/Master (can send) vs. Client (receive only)')
    print('  /lra send <page name>  - broadcast a saved page (Master only)')
    print('  /lra show | hide        - toggle the banner display')
    print('  /lra panel show|hide   - toggle the control window')
    print('  /lra announce on|off   - toggle broadcasting entirely (Master only)')
    print('  /lra debug on|off      - print every raw incoming chat line')
    print('  /lra exit              - unload this script')
end

mq.bind('/lra', function(...)
    local args = { ... }
    local sub = string.lower(args[1] or '')

    if sub == 'send' then
        table.remove(args, 1)
        sendPageByName(trim(table.concat(args, ' ')))
    elseif sub == 'show' then
        state.bannerShow = true
    elseif sub == 'hide' then
        state.bannerShow = false
    elseif sub == 'panel' then
        local mode = string.lower(args[2] or '')
        state.controlOpen = (mode ~= 'hide')
    elseif sub == 'master' then
        local mode = string.lower(args[2] or '')
        local was = state.isMaster
        state.isMaster = (mode ~= 'off')
        if state.isMaster ~= was then
            saveSettingsToDisk()
        end
        print('[LRA] role: ' .. (state.isMaster and 'Raid Leader / Master' or 'Client (receive only)'))
    elseif sub == 'announce' then
        local mode = string.lower(args[2] or '')
        state.announce = (mode ~= 'off')
        print('[LRA] broadcasting: ' .. (state.announce and 'ON' or 'OFF'))
    elseif sub == 'debug' then
        local mode = string.lower(args[2] or '')
        state.debug = (mode ~= 'off')
        print('[LRA] raw chat debug: ' .. (state.debug and 'ON' or 'OFF'))
    elseif sub == 'exit' or sub == 'quit' then
        RUNNING = false
    else
        printHelp()
    end
end)

--------------------------------------------------------------------------
-- on-screen windows
--------------------------------------------------------------------------

-- degrades to a plain window instead of erroring if flags aren't supported
local warnedBeginFallback = false
local function safeBegin(title, open, flags)
    if flags then
        local ok, a, b = pcall(ImGui.Begin, title, open, flags)
        if ok then
            return a, b
        end
        if not warnedBeginFallback then
            print('[LRA] note: borderless banner mode not supported on this build, using a normal window instead.')
            warnedBeginFallback = true
        end
    end
    return ImGui.Begin(title, open)
end

-- handles both GetWindowSize calling conventions: a Vec2-like table with
-- .x/.y, or two separate numeric returns
local function getWindowSize()
    local ok, a, b = pcall(ImGui.GetWindowSize)
    if not ok or a == nil then
        return nil, nil
    end
    if type(a) == 'table' then
        return a.x, a.y
    end
    if type(a) == 'number' then
        return a, b
    end
    return nil, nil
end

--------------------------------------------------------------------------
-- theming: a colored accent per section/action "kind", TurboSuite's own
-- visual language. Every push below is pcall-wrapped and paired with a
-- COUNT-based pop (never a fixed number), so a partial failure - or a
-- build missing these ImGuiCol/PushStyleColor calls entirely - can't
-- leave a mismatched style stack; it just falls back to plain widgets.
--------------------------------------------------------------------------

local COLOR_GREEN  = { 60, 120,  80 }  -- Save / Send / commit actions
local COLOR_BLUE   = { 70, 100, 150 }  -- neutral / Edit / New / page editor
local COLOR_GOLD   = {150, 110,  40 }  -- Kill Order Target+Mark
local COLOR_RED    = {150,  60,  60 }  -- Delete
local COLOR_PURPLE = { 90,  82, 130 }  -- Banner settings
local COLOR_GRAY   = { 90,  90, 100 }  -- Minimize / neutral / no-marker-left

-- each push is its own pcall (not one around all 3) so a mid-way failure
-- still reports the true count pushed, not a swallowed false 0
local function pushButtonColor(rgb)
    local function lighten(v) return math.min(v + 25, 255) end
    local base, hover
    pcall(function()
        base  = IM_COL32(rgb[1], rgb[2], rgb[3], 255)
        hover = IM_COL32(lighten(rgb[1]), lighten(rgb[2]), lighten(rgb[3]), 255)
    end)
    if base == nil then
        return 0
    end
    local pushed = 0
    if not pcall(ImGui.PushStyleColor, ImGuiCol.Button, base) then
        return pushed
    end
    pushed = 1
    if not pcall(ImGui.PushStyleColor, ImGuiCol.ButtonHovered, hover) then
        return pushed
    end
    pushed = 2
    if not pcall(ImGui.PushStyleColor, ImGuiCol.ButtonActive, base) then
        return pushed
    end
    pushed = 3
    return pushed
end

local function popColors(n)
    if n and n > 0 then
        pcall(ImGui.PopStyleColor, n)
    end
end

local function coloredSeparator(rgb, alpha)
    local pushed = false
    pcall(function()
        ImGui.PushStyleColor(ImGuiCol.Separator, IM_COL32(rgb[1], rgb[2], rgb[3], alpha or 120))
        pushed = true
    end)
    ImGui.Separator()
    if pushed then
        pcall(ImGui.PopStyleColor, 1)
    end
end

-- caller must call ImGui.SameLine() afterward for more content on the same line
local function inlineDot(rgb)
    pcall(function()
        local fontSize = ImGui.GetFontSize()
        local radius = math.max(3, math.floor(fontSize * 0.30))
        local cx, cy = ImGui.GetCursorScreenPos()
        local centerY = cy + math.floor(fontSize * 0.5) + 1
        local centerX = cx + radius + 2
        local drawList = ImGui.GetWindowDrawList()
        drawList:AddCircleFilled(ImVec2(centerX, centerY), radius, IM_COL32(rgb[1], rgb[2], rgb[3], 255), 0)
        ImGui.Dummy(radius * 2 + 6, 1)
    end)
end

local function sectionHeaderDot(rgb, label)
    coloredSeparator(rgb)
    local drew = false
    pcall(function()
        inlineDot(rgb)
        ImGui.SameLine(0, 0)
        ImGui.TextColored(rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 1.0, label)
        drew = true
    end)
    if not drew then
        ImGui.Text(label)
    end
end

-- fallback (plain red "X" button) reports the identical click either way
local function stopSignButton(id, size)
    size = size or 22
    local ok, clicked = pcall(function()
        local x, y = ImGui.GetCursorScreenPos()
        ImGui.InvisibleButton(id, size, size)
        local isClicked = ImGui.IsItemClicked()
        local hovered = ImGui.IsItemHovered()
        local drawList = ImGui.GetWindowDrawList()
        local cx, cy = x + size * 0.5, y + size * 0.5
        local radius = math.max(8, size * 0.46)
        local red = hovered and IM_COL32(210, 50, 45, 255) or IM_COL32(160, 38, 36, 255)
        drawList:AddCircleFilled(ImVec2(cx, cy), radius, red, 8)
        local barHalfW = radius * 0.55
        local barHalfH = math.max(1.2, radius * 0.13)
        drawList:AddRectFilled(ImVec2(cx - barHalfW, cy - barHalfH), ImVec2(cx + barHalfW, cy + barHalfH),
                                IM_COL32(255, 248, 240, 255), 1.0)
        return isClicked
    end)
    if ok then
        return clicked
    end
    local n = pushButtonColor(COLOR_RED)
    local fallbackClicked = ImGui.Button('X##' .. id)
    popColors(n)
    return fallbackClicked
end

local CONTROL_FULL_W, CONTROL_FULL_H = 460, 620

-- mq.luaDir is the BASE lua/ folder, not this script's own folder, so the
-- path below needs the "LRA/" prefix explicitly
local MINI_ICON_SIZE = 48  -- matches TurboGear's own standalone mini-icon "restore" button (its non-small default)
local ICON_RELATIVE_PATH = 'LRA/LRA_icon.png'
local iconTex = nil

local function loadIconTexture()
    pcall(function()
        local path = string.format('%s/%s', mq.luaDir, ICON_RELATIVE_PATH)
        iconTex = mq.CreateTexture(path)
    end)
end

-- Mini view is a SEPARATE window identity from the full panel (not the
-- same window resized), so each keeps its own remembered position/size.
local MINI_TITLE = 'LRA###LRA_Mini'
local FULL_TITLE = 'Lazarus Raid Assignments'

-- ImGui.Begin returns (open, shouldDraw). Mixing these up was the actual
-- root cause of the earlier "minimize arrow gets stuck" bug: shouldDraw
-- (false while collapsed) was getting stored into the persisted open
-- state, so collapsing stopped the window from ever calling Begin again.

-- PushStyleColor here takes (col, r, g, b, a) as 4 separate normalized
-- floats, not the packed IM_COL32 form pushButtonColor uses elsewhere -
-- both work, this just matches what TurboGear's own source calls.
local function pushMiniBadgeStyle()
    local varsPushed, colorsPushed = 0, 0
    if pcall(function() ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 2.5) end) then varsPushed = varsPushed + 1 end
    if pcall(function() ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 10.0) end) then varsPushed = varsPushed + 1 end
    if pcall(function() ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, ImVec2(8, 8)) end) then varsPushed = varsPushed + 1 end
    if pcall(function() ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, ImVec2(0, 0)) end) then varsPushed = varsPushed + 1 end
    if pcall(function() ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, ImVec2(0, 0)) end) then varsPushed = varsPushed + 1 end
    if pcall(function() ImGui.PushStyleColor(ImGuiCol.WindowBg, 0.060, 0.075, 0.115, 0.98) end) then colorsPushed = colorsPushed + 1 end
    if pcall(function() ImGui.PushStyleColor(ImGuiCol.Border, 1.00, 0.74, 0.28, 0.94) end) then colorsPushed = colorsPushed + 1 end
    return varsPushed, colorsPushed
end

local function popMiniBadgeStyle(varsPushed, colorsPushed)
    if colorsPushed > 0 then pcall(ImGui.PopStyleColor, colorsPushed) end
    if varsPushed > 0 then pcall(ImGui.PopStyleVar, varsPushed) end
end

local function drawMiniPanel()
    local flags = nil
    pcall(function()
        flags = bit32.bor(ImGuiWindowFlags.AlwaysAutoResize, ImGuiWindowFlags.NoResize,
                           ImGuiWindowFlags.NoTitleBar, ImGuiWindowFlags.NoScrollbar)
    end)

    -- pushed before Begin/popped after End() unconditionally, so the stack
    -- always balances even if iconTex/ImGui.Image show up or disappear
    -- mid-session
    local haveIconPath = (iconTex and ImGui.Image) and true or false
    local varsPushed, colorsPushed = 0, 0
    if haveIconPath then
        varsPushed, colorsPushed = pushMiniBadgeStyle()
    end

    local shouldDraw
    state.controlOpen, shouldDraw = safeBegin(MINI_TITLE, state.controlOpen, flags)
    if shouldDraw then
        local usedIcon = false
        if haveIconPath then
            local drewIcon, clicked = pcall(function()
                local texId = iconTex:GetTextureID()
                ImGui.Image(texId, ImVec2(MINI_ICON_SIZE, MINI_ICON_SIZE))
                local wasClicked = (ImGui.IsItemClicked and ImGui.IsItemClicked(0)) == true
                pcall(function()
                    if ImGui.IsItemHovered and ImGui.IsItemHovered() and ImGui.SetTooltip then
                        ImGui.SetTooltip('Click to restore Lazarus Raid Assignments')
                    end
                end)
                return wasClicked
            end)
            if drewIcon then
                usedIcon = true
                if clicked then
                    state.controlMinimized = false
                end
            end
        end

        if not usedIcon then
            local n = pushButtonColor(state.isMaster and COLOR_GREEN or COLOR_GRAY)
            if ImGui.Button('LRA v##lra_restore') then
                state.controlMinimized = false
            end
            popColors(n)
        end
    end
    ImGui.End()

    if haveIconPath then
        popMiniBadgeStyle(varsPushed, colorsPushed)
    end
end

local function drawFullPanel()
    -- NoCollapse: the Minimize button below is the supported way to shrink
    -- this window, not the native collapse arrow
    local flags = nil
    pcall(function() flags = ImGuiWindowFlags.NoCollapse end)

    ImGui.SetNextWindowSize(CONTROL_FULL_W, CONTROL_FULL_H, ImGuiCond.FirstUseEver)
    local shouldDraw
    state.controlOpen, shouldDraw = safeBegin(FULL_TITLE, state.controlOpen, flags)
    if shouldDraw then
        local nMin = pushButtonColor(COLOR_GRAY)
        if ImGui.Button('- Minimize') then
            state.controlMinimized = true
        end
        popColors(nMin)
        ImGui.SameLine()
        if inRaid() then
            ImGui.Text('Broadcast channel: RAID')
        else
            ImGui.Text('Broadcast channel: GROUP (join a raid to reach the whole raid)')
        end

        inlineDot(state.isMaster and COLOR_GREEN or COLOR_GRAY)
        ImGui.SameLine(0, 4)
        local wasMaster = state.isMaster
        state.isMaster = ImGui.Checkbox('Raid Leader / Master (create & send assignments)', state.isMaster)
        if state.isMaster ~= wasMaster then
            saveSettingsToDisk()
        end

        if state.isMaster then
            state.announce = ImGui.Checkbox('Broadcasting enabled', state.announce)

            sectionHeaderDot(COLOR_BLUE, 'PAGE EDITOR')

            ImGui.Text('Import page code:')
            state.importText = ImGui.InputText('##importText', state.importText, CODE_MAXLEN)
            ImGui.SameLine()
            local nPaste = pushButtonColor(COLOR_BLUE)
            if ImGui.Button('Paste##importPaste') then
                local ok, clip = pcall(ImGui.GetClipboardText)
                if ok and clip then
                    state.importText = clip
                else
                    print('[LRA] clipboard access isn\'t available on this build - paste into the field manually.')
                end
            end
            popColors(nPaste)
            ImGui.SameLine()
            local nImport = pushButtonColor(COLOR_BLUE)
            if ImGui.Button('Import##importGo') then
                local page, err = importStringToPage(state.importText)
                if page then
                    state.editName = page.name
                    state.editLines = (#page.lines > 0) and page.lines or { '' }
                    state.editKillOrder = (#page.killOrder > 0) and page.killOrder or { '' }
                    state.editingIndex = nil
                    state.importText = ''
                    print(string.format('[LRA] imported "%s" into the editor below - click Save to keep it.', page.name))
                else
                    print('[LRA] import failed: ' .. tostring(err))
                end
            end
            popColors(nImport)

            ImGui.Text(state.editingIndex and 'Editing saved page:' or 'New saved page:')
            state.editName = ImGui.InputText('Page Name', state.editName, INPUT_MAXLEN)

            ImGui.Text('Lines:')
            local removeIdx = nil
            for i, line in ipairs(state.editLines) do
                state.editLines[i] = ImGui.InputText('##line' .. i, line, INPUT_MAXLEN)
                ImGui.SameLine()
                if ImGui.Button('X##removeline' .. i) then
                    removeIdx = i
                end
            end
            if removeIdx then
                table.remove(state.editLines, removeIdx)
                if #state.editLines == 0 then
                    state.editLines = { '' }
                end
            end
            if ImGui.Button('+ Add Line') then
                table.insert(state.editLines, '')
            end

            sectionHeaderDot(COLOR_GOLD, 'KILL ORDER')
            ImGui.Text('Marks your own client\'s current target - local only, not broadcast.')
            ImGui.Text('Target the NPC yourself in-game, then click its row\'s Mark button.')
            ImGui.Text('Row 1/2/3 mark with raid marker 1/2/3; EQ has no markers past 3.')
            local removeKoIdx = nil
            for i, koName in ipairs(state.editKillOrder) do
                state.editKillOrder[i] = ImGui.InputText('##ko' .. i, koName, INPUT_MAXLEN)
                ImGui.SameLine()
                if i <= 3 then
                    local nMark = pushButtonColor(COLOR_GOLD)
                    if ImGui.Button('Mark ' .. i .. '##komark' .. i) then
                        markCurrentTarget(i)
                    end
                    popColors(nMark)
                else
                    ImGui.Text('(no marker slot left)')
                end
                ImGui.SameLine()
                if ImGui.Button('X##removeko' .. i) then
                    removeKoIdx = i
                end
            end
            if removeKoIdx then
                table.remove(state.editKillOrder, removeKoIdx)
                if #state.editKillOrder == 0 then
                    state.editKillOrder = { '' }
                end
            end
            if ImGui.Button('+ Add Kill Target') then
                table.insert(state.editKillOrder, '')
            end

            ImGui.Separator()
            local nSave = pushButtonColor(COLOR_GREEN)
            if ImGui.Button('Save') then
                savePage(false)
            end
            popColors(nSave)
            ImGui.SameLine()
            nSave = pushButtonColor(COLOR_GREEN)
            if ImGui.Button('Save & Send') then
                savePage(true)
            end
            popColors(nSave)
            ImGui.SameLine()
            local nNew = pushButtonColor(COLOR_BLUE)
            if ImGui.Button('New') then
                beginNewPage()
            end
            popColors(nNew)

            sectionHeaderDot(COLOR_GREEN, 'SAVED PAGES')
            if #state.pages == 0 then
                ImGui.Text('(none yet - create one above)')
            else
                ImGui.Text('Drag a page name to reorder it in the list.')
                -- guard against a stale pendingDeleteIndex pointing past the list
                if state.pendingDeleteIndex and
                    (state.pendingDeleteIndex < 1 or state.pendingDeleteIndex > #state.pages) then
                    state.pendingDeleteIndex = nil
                end

                for i, p in ipairs(state.pages) do
                    local nSend = pushButtonColor(COLOR_GREEN)
                    if ImGui.Button('Send##send' .. i) then
                        sendPageByIndex(i)
                    end
                    popColors(nSend)
                    ImGui.SameLine()
                    local nEdit = pushButtonColor(COLOR_BLUE)
                    if ImGui.Button('Edit##edit' .. i) then
                        beginEditPage(i)
                    end
                    popColors(nEdit)
                    ImGui.SameLine()
                    local nExport = pushButtonColor(COLOR_BLUE)
                    if ImGui.Button('Export##export' .. i) then
                        state.exportText = exportPageToString(p)
                        if pcall(ImGui.SetClipboardText, state.exportText) then
                            print(string.format('[LRA] exported "%s" - code copied to clipboard.', p.name))
                        else
                            print(string.format(
                                '[LRA] exported "%s" - copy the code shown below (clipboard access unavailable on this build).', p.name))
                        end
                    end
                    popColors(nExport)
                    ImGui.SameLine()

                    -- stop-sign only ARMS the row; deletePage() runs only on "Confirm"
                    if state.pendingDeleteIndex == i then
                        local nConfirm = pushButtonColor(COLOR_RED)
                        if ImGui.Button('Confirm delete##delconfirm' .. i) then
                            deletePage(i)
                            state.pendingDeleteIndex = nil
                        end
                        popColors(nConfirm)
                        ImGui.SameLine()
                        local nCancel = pushButtonColor(COLOR_GRAY)
                        if ImGui.Button('Cancel##delcancel' .. i) then
                            state.pendingDeleteIndex = nil
                        end
                        popColors(nCancel)
                    else
                        if stopSignButton('delete' .. i) then
                            state.pendingDeleteIndex = i
                        end
                    end
                    ImGui.SameLine()
                    local drewSelectable = pcall(function()
                        ImGui.Selectable(p.name .. '##pagename' .. i, false)
                    end)
                    if not drewSelectable then
                        ImGui.Text(p.name)
                    end
                    -- drag-to-reorder attaches to whichever name widget was
                    -- just drawn above; degrades to a static (non-draggable)
                    -- row if this build lacks the drag-drop calls entirely
                    pcall(function()
                        if ImGui.BeginDragDropSource(ImGuiDragDropFlags.SourceNoPreviewTooltip) then
                            ImGui.SetDragDropPayload('LRA_PAGE_REORDER', i)
                            ImGui.Text('Move "' .. p.name .. '"')
                            ImGui.EndDragDropSource()
                        end
                        if ImGui.BeginDragDropTarget() then
                            local payload = ImGui.AcceptDragDropPayload('LRA_PAGE_REORDER')
                            if payload then
                                movePage(payload.Data, i)
                            end
                            ImGui.EndDragDropTarget()
                        end
                    end)
                end
            end

            if state.exportText then
                ImGui.Separator()
                ImGui.Text('Exported page code (select all, Ctrl+C to copy):')
                state.exportText = ImGui.InputText('##exportTextDisplay', state.exportText, CODE_MAXLEN)
            end
        else
            ImGui.Separator()
            ImGui.Text('Client mode: this just displays assignments your')
            ImGui.Text('raid leader sends - nothing to set up here.')
            ImGui.Text('Check the box above if you need to author/send too.')
        end

        sectionHeaderDot(COLOR_PURPLE, 'BANNER')
        state.bannerShow = ImGui.Checkbox('Show banner', state.bannerShow)
        state.combatHide = ImGui.Checkbox('Hide banner while in combat', state.combatHide)
        state.lockPosition = ImGui.Checkbox('Lock banner position', state.lockPosition)
        state.autoSize = ImGui.Checkbox('Auto-size banner to content', state.autoSize)
        if not state.autoSize then
            ImGui.Text('(drag the banner\'s corner to resize it; a scrollbar')
            ImGui.Text('appears if a note has more lines than fit)')
        end
    end
    ImGui.End()
end

local function drawControlPanel()
    if not state.controlOpen then
        return
    end
    if state.controlMinimized then
        drawMiniPanel()
    else
        drawFullPanel()
    end
end

local function drawBanner()
    if not state.bannerShow then
        return
    end
    if not state.activeNote or #state.activeNote.lines == 0 then
        return
    end
    if state.combatHide then
        local ok, combat = pcall(function() return mq.TLO.Me.Combat() end)
        if ok and combat then
            return
        end
    end

    -- auto-size: AlwaysAutoResize fits the window to the note; otherwise the
    -- window is resizable and NoScrollbar is dropped so an oversized note
    -- scrolls instead of clipping
    local flags = nil
    pcall(function()
        flags = bit32.bor(ImGuiWindowFlags.NoTitleBar, ImGuiWindowFlags.NoCollapse)
        if state.autoSize then
            flags = bit32.bor(flags, ImGuiWindowFlags.NoResize, ImGuiWindowFlags.NoScrollbar,
                               ImGuiWindowFlags.AlwaysAutoResize)
        end
        if state.lockPosition then
            flags = bit32.bor(flags, ImGuiWindowFlags.NoMove)
        end
    end)

    ImGui.SetNextWindowPos(200, 120, ImGuiCond.FirstUseEver)
    if not state.autoSize then
        ImGui.SetNextWindowSize(420, 220, ImGuiCond.FirstUseEver)
    end

    -- banner has no title bar/close button, so only shouldDraw matters here
    local _, visible = safeBegin('##killorder_banner', true, flags)
    if visible then
        -- only scale font off window size in manual-resize mode; in
        -- auto-size mode the window size is DERIVED from the font scale, so
        -- doing it there would feed back into itself and spiral
        local effectiveScale = state.fontScale
        if not state.autoSize then
            local w, h = getWindowSize()
            if w and h and w > 0 and h > 0 then
                local ratio = math.min(w / BANNER_BASE_W, h / BANNER_BASE_H)
                effectiveScale = state.fontScale * ratio
                if effectiveScale < BANNER_MIN_SCALE then
                    effectiveScale = BANNER_MIN_SCALE
                elseif effectiveScale > BANNER_MAX_SCALE then
                    effectiveScale = BANNER_MAX_SCALE
                end
            end
        end
        pcall(ImGui.SetWindowFontScale, effectiveScale)

        -- only wrap in manual-resize mode; auto-size grows to fit instead,
        -- and wrapping there would fight AlwaysAutoResize
        local wrapped = false
        if not state.autoSize then
            wrapped = pcall(ImGui.PushTextWrapPos, 0.0)
        end

        local age = os.clock() - state.activeNote.receivedAt
        if age < FLASH_SECONDS then
            ImGui.Text('*** UPDATED ***')
        end
        ImGui.Text(state.activeNote.pageName)
        ImGui.Separator()
        for _, line in ipairs(state.activeNote.lines) do
            ImGui.Text(line)
        end

        if wrapped then
            pcall(ImGui.PopTextWrapPos)
        end
        pcall(ImGui.SetWindowFontScale, 1.0)
    end
    ImGui.End()
end

mq.imgui.init(SCRIPT_NAME .. '_control', drawControlPanel)
mq.imgui.init(SCRIPT_NAME .. '_banner', drawBanner)

loadPagesFromDisk()
loadSettingsFromDisk()
loadIconTexture()
print(string.format('[LRA] loaded (%d saved page(s), role: %s). Type /lra for optional commands.',
    #state.pages, state.isMaster and 'Master' or 'Client'))

--------------------------------------------------------------------------
-- main loop
--------------------------------------------------------------------------

while RUNNING do
    mq.doevents()
    pumpSendQueue()
    pruneStaleIncoming()
    mq.delay(100)
end

mq.imgui.destroy(SCRIPT_NAME .. '_control')
mq.imgui.destroy(SCRIPT_NAME .. '_banner')
print('[LRA] unloaded.')
