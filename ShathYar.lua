--[[

  RELOADED LICENSE:

  Shath'Yar Language Addon for WoW
  Copyright © 2018, Franzetta-DarkIron
  Copyright © 2025, Illbjorn-Stormrage

  This program is free software. It comes without any warranty, to the extent
  permitted by applicable law. You can redistribute it and/or modify it under
  the terms of the MIT License. See the LICENSE file for more details.

  ORIGINAL LICENSE:

  Shath'Yar Language Addon for WoW
  Copyright © 2018, Franzetta-DarkIron

  This program is free software. It comes without any warranty, to
  the extent permitted by applicable law. You can redistribute it
  and/or modify it under the terms of the Do What The Fuck You Want
  To Public License, Version 2, as published by Sam Hocevar. See the
  COPYING file for more details.

]] --

local shathYarSounds = {
  {
    'i'
  },
  {
    'ag',
    'ez',
    'ga',
    'ky',
    'ma',
    'ni',
    'og',
    'za',
    'zz'
  },
  {
    'gag',
    'hoq',
    'lal',
    'maq',
    'nuq',
    'oou',
    'qam',
    'shn',
    'vaz',
    'vra',
    'yrr',
    'zuq'
  },
  {
    'agth',
    'amun',
    'arwi',
    'fssh',
    'ifis',
    'kyth',
    'nuul',
    'ongg',
    'puul',
    'qwaz',
    'qwor',
    'ryiu',
    'shfk',
    'thoq',
    'uull',
    'vwah',
    'vwyq',
    "w'oq",
    'wgah',
    'ywaq',
    'zaix',
    'zzof'
  },
  {
    "ag'rr",
    'agthu',
    "ak'uq",
    'anagg',
    "bo'al",
    'fhssh',
    "h'iwn",
    'hnakf',
    'huqth',
    'iilth',
    'iiyoq',
    'lwhuk',
    "on'ma",
    'plahf',
    'shkul',
    'shuul',
    'thyzz',
    'uulwi',
    'vorzz',
    "w'ssh",
    'yyqzz'
  },
  {
    "ag'xig",
    "al'tha",
    "an'qov",
    "an'zig",
    'bormaz',
    "c'toth",
    "far'al",
    "h'thon",
    'halahs',
    'iggksh',
    "ka'kar",
    'kaaxth',
    'marwol',
    "n'zoth",
    'qualar',
    'qvsakf',
    "shn'ma",
    "sk'tek",
    'skshgn',
    'ssaggh',
    'tallol',
    'tulall',
    'uhnish',
    'uovssh',
    'vormos',
    'yawifk',
    "yoq'al",
    "yu'gaz"
  },
  {
    "an'shel",
    'awtgssh',
    "guu'lal",
    'guulphg',
    'iiqaath',
    "kssh'ga",
    "mh'naus",
    "n'lyeth",
    "ph'magg",
    'qornaus',
    'shandai',
    "shg'cul",
    "shg'fhn",
    "sk'magg",
    "sk'yahf",
    "uul'gwa",
    "uulg'ma",
    'vwahuhn',
    "woth'gl",
    "yeh'glu",
    "yyg'far",
    'zyqtahg'
  },
  {
    'awtgsshu',
    "erh'ongg",
    "gul'kafh",
    'halsheth',
    "log'loth",
    "mar'kowa",
    "muoq'vsh",
    'phquathi',
    "qi'plahf",
    "qi'uothk",
    "sk'shuul",
    "sk'uuyat",
    "ta'thall",
    "thoth'al",
    "uhn'agth",
    "ye'tarin",
    "yoh'ghyl",
    "zuq'nish"
  },
  {
    "ag'thyzak",
    "ga'halahs",
    "lyrr'keth",
    "par'okoth",
    "phgwa'cul",
    "pwhn'guul",
    "ree'thael",
    "shath'yar",
    "shgla'yos",
    "shuul'wah",
    "sshoq'meg"
  },
  {
    "ak'agthshi",
    "shg'ullwaq",
    "sk'woth'gl"
  },
  {
    "ghawl'fwata",
    "naggwa'fssh",
    "yeq'kafhgyl"
  },
}

local hashConstants = {
  0x486e26ee,
  0xdcaa16b3,
  0xe1918eef,
  0x202dafdb,
  0x341c7dc7,
  0x1c365303,
  0x40ef2d37,
  0x65fd5e49,
  0xd6057177,
  0x904ece93,
  0x1c38024f,
  0x98fd323b,
  0xe3061ae7,
  0xa39b0fa1,
  0x9797f25f,
  0xe4444563,
  0xdcaa16b3,
  0x486e26ee,
  0x202dafdb,
  0xe1918eef,
  0x1c365303,
  0x341c7dc7,
  0x65fd5e49,
  0x40ef2d37,
  0x904ece93,
  0xd6057177,
  0x98fd323b,
  0x1c38024f,
  0xa39b0fa1,
  0xe3061ae7,
  0xe4444563,
  0x9797f25f,
  0x8dc1b898,
  0xcd2ec20c,
  0x799a306d,
  0x31759633,
  0x2e6e9627,
  0x8c206385,
  0x73922c66,
  0x79237d99,
  0x28628824,
  0x8728628d,
  0x25887795,
  0x8f1f7e96,
  0x389c0d60,
  0x296e3281,
  0x61636542,
  0x6f4893ca,
}


--- This is a relatively arbitrary hashing function derived from SStrHash,
--- which itself is purportedly the algorithm used to hash MPQ files.
--- @param word string
--- @return number
local function hashWord(word)
  local seed1 = 0x7FED7FED
  local seed2 = 0xEEEEEEEE

  --- Upper-case the entire word
  word = string.upper(word)

  for i = 1, word:len() do
    --- Get byte representation of this letter
    local charByte = word:byte(i)

    --- Shift right 4
    local shifted = bit.rshift(charByte, 4) + 1
    --- Mask last 4 bits
    local masked = bit.band(charByte, 0xf) + 1
    --- Fetch a constant by the shifted resut
    local c1 = hashConstants[shifted]
    --- Fetch a constant by the masked result
    local c2 = hashConstants[masked]
    local xorBy = c1 - c2

    seed1 = bit.bxor(seed1 + seed2, xorBy)
    seed2 = bit.lshift(seed2, 5) + seed2 + charByte + seed1 + 3
  end

  return seed1
end

--- Matches the casing of the original message.
--- @param msg string
--- @param to_match string
--- @return stringView
local function matchCase(msg, to_match)
  local chars = {}
  for char in msg:gmatch('.') do
    table.insert(chars, char)
  end

  local matchChars = {}
  for matchChar in to_match:gmatch('.') do
    table.insert(matchChars, matchChar)
  end

  local ret = ''
  for i = 1, #chars do
    if matchChars[i] == string.upper(matchChars[i]) then
      ret = ret .. string.upper(chars[i])
    else
      ret = ret .. string.lower(chars[i])
    end
  end

  return ret
end

--- Translates a message to Shath'yar.
--- @param msg string
--- @return string
local function translate(msg)
  --- Break the original message into individual words
  local words = {}
  for word in msg:gmatch("[A-Za-z0-9']+") do
    table.insert(words, word)
  end

  local syWords = {}
  for _, word in pairs(words) do
    local soundsTable = shathYarSounds[word:len()]
    if soundsTable == nil then
      soundsTable = shathYarSounds[#shathYarSounds]
    end

    --- Hash the word and mod it by length of sounds + 1
    local hashed = hashWord(word) % #soundsTable + 1
    --- Get the shath'yar word at the hashed index
    local syWord = soundsTable[hashed]
    --- Match casing of the original message
    local syWordCased = matchCase(syWord, word)

    table.insert(syWords, syWordCased)
  end

  return table.concat(syWords, ' ')
end

--- @param msg string
--- @param chatType ChatType
local function emit(msg, chatType)
  --- Collect the player's language ID
  local _, language = GetDefaultLanguage()

  --- Check if we're in Voidform
  --- If the player is in Voidform, we don't garble the output (player speaks
  --- Shath'yar)
  local inVoidform = false
  for i = 1, 40 do
    local auraData = C_UnitAuras.GetAuraDataByIndex(
      'player',
      i
    )

    if auraData ~= nil then
      if auraData.spellId == 194249 then
        inVoidform = true
      end
    end
  end

  if inVoidform then
    SendChatMessage(msg, chatType, language)
  else
    SendChatMessage(
      "[Shath'Yar] " .. translate(msg),
      chatType,
      language
    )
  end
end

SLASH_SYSAY1 = "/sy"
SLASH_SYSAY2 = "/sys"
SLASH_SYSAY3 = "/sysay"
SlashCmdList["SYSAY"] = function(msg)
  emit(msg, "SAY")
end

SLASH_SYYELL1 = "/syy"
SLASH_SYYELL2 = "/syyell"
SlashCmdList["SYYELL"] = function(msg)
  emit(msg, "YELL")
end

SLASH_SYPRINT2 = "/syprint"
SlashCmdList["SYPRINT"] = function(msg)
  print(translate(msg))
end

SLASH_SYGUILD1 = "/syg"
SLASH_SYGUILD2 = "/syguild"
SlashCmdList["SYGUILD"] = function(msg)
  emit(msg, "GUILD")
end

SLASH_SYRAID1 = "/syr"
SLASH_SYRAID2 = "/syraid"
SlashCmdList["SYRAID"] = function(msg)
  emit(msg, "RAID")
end

SLASH_SYRAIDW1 = "/syrw"
SLASH_SYRAIDW2 = "/syraidw"
SlashCmdList["SYRAIDW"] = function(msg)
  emit(msg, "RAID_WARNING")
end

SLASH_SYPARTY1 = "/syp"
SLASH_SYPARTY2 = "/syparty"
SlashCmdList["SYPARTY"] = function(msg)
  emit(msg, "PARTY")
end
