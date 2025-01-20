--[[

  Shath'Yar Language Addon for WoW
  Copyright © 2018, Franzetta-DarkIron

  This program is free software. It comes without any warranty, to
  the extent permitted by applicable law. You can redistribute it
  and/or modify it under the terms of the Do What The Fuck You Want
  To Public License, Version 2, as published by Sam Hocevar. See the
  COPYING file for more details.

]] --

local shathYarSounds = {
  { 'i' },
  { 'ag',  'ez',  'ga',  'ky',  'ma',  'ni',  'og',  'za',  'zz' },
  { 'gag', 'hoq', 'lal', 'maq', 'nuq', 'oou', 'qam', 'shn', 'vaz', 'vra', 'yrr', 'zuq' },
  { 'agth', 'amun', 'arwi', 'fssh', 'ifis', 'kyth', 'nuul', 'ongg', 'puul', 'qwaz', 'qwor', 'ryiu', 'shfk', 'thoq',
    'uull', 'vwah', 'vwyq', "w'oq",
    'wgah', 'ywaq', 'zaix', 'zzof' },
  { "ag'rr", 'agthu', "ak'uq", 'anagg', "bo'al", 'fhssh', "h'iwn", 'hnakf',
    'huqth', 'iilth', 'iiyoq', 'lwhuk', "on'ma", 'plahf', 'shkul', 'shuul',
    'thyzz', 'uulwi', 'vorzz', "w'ssh", 'yyqzz' },
  { "ag'xig", "al'tha", "an'qov", "an'zig", 'bormaz', "c'toth", "far'al",
    "h'thon", 'halahs', 'iggksh', "ka'kar", 'kaaxth', 'marwol', "n'zoth",
    'qualar', 'qvsakf', "shn'ma", "sk'tek", 'skshgn', 'ssaggh', 'tallol',
    'tulall', 'uhnish', 'uovssh', 'vormos', 'yawifk', "yoq'al", "yu'gaz" },
  { "an'shel", 'awtgssh', "guu'lal", 'guulphg', 'iiqaath', "kssh'ga",
    "mh'naus", "n'lyeth", "ph'magg", 'qornaus', 'shandai', "shg'cul",
    "shg'fhn", "sk'magg", "sk'yahf", "uul'gwa", "uulg'ma", 'vwahuhn',
    "woth'gl", "yeh'glu", "yyg'far", 'zyqtahg' },
  { 'awtgsshu', "erh'ongg", "gul'kafh", 'halsheth', "log'loth", "mar'kowa",
    "muoq'vsh", 'phquathi', "qi'plahf", "qi'uothk", "sk'shuul", "sk'uuyat",
    "ta'thall", "thoth'al", "uhn'agth", "ye'tarin", "yoh'ghyl", "zuq'nish" },
  { "ag'thyzak", "ga'halahs", "lyrr'keth", "par'okoth", "phgwa'cul",
    "pwhn'guul", "ree'thael", "shath'yar", "shgla'yos", "shuul'wah",
    "sshoq'meg" },
  { "ak'agthshi",  "shg'ullwaq",  "sk'woth'gl" },
  { "ghawl'fwata", "naggwa'fssh", "yeq'kafhgyl" },
}

SStrHash_constants = {
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

function SStrHash(word)
  local seed1 = 0x7FED7FED
  local seed2 = 0xEEEEEEEE

  word = string.upper(word)

  for i = 1, word:len() do
    local ch = word:byte(i)
    seed1 = bit.bxor(seed1 + seed2,
      (SStrHash_constants[bit.rshift(ch, 4) + 1] -
        SStrHash_constants[bit.band(ch, 0xf) + 1]))
    seed2 = bit.lshift(seed2, 5) + seed2 + ch + seed1 + 3
  end

  return seed1
end

function ShathYar_MatchCase(msg, to_match)
  local msg_letters = {}
  for msg_letter in msg:gmatch('.') do
    table.insert(msg_letters, msg_letter)
  end

  local match_letters = {}
  for match_letter in to_match:gmatch('.') do
    table.insert(match_letters, match_letter)
  end

  local sy_letters = {}
  for i = 1, #msg_letters do
    if match_letters[i] == string.upper(match_letters[i]) then
      table.insert(sy_letters, string.upper(msg_letters[i]))
    else
      table.insert(sy_letters, string.lower(msg_letters[i]))
    end
  end

  return table.concat(sy_letters, '')
end

function ShathYar_Translate(msg)
  local words = {}
  for word in msg:gmatch("[A-Za-z0-9']+") do
    table.insert(words, word)
  end

  local sy_words = {}
  for k, word in pairs(words) do
    local table_for_len = shathYarSounds[word:len()]
    if table_for_len == nil then
      table_for_len = shathYarSounds[#shathYarSounds]
    end

    local table_word = table_for_len[(SStrHash(word) % #table_for_len) + 1]
    table.insert(sy_words, ShathYar_MatchCase(table_word, word))
  end

  return table.concat(sy_words, ' ')
end

function ShathYar_SendChatMessage(msg, chatType)
  local _, language = GetDefaultLanguage()

  local in_voidform = false
  for i = 1, 40 do
    local aura_data = C_UnitAuras.GetAuraDataByIndex(
      'player',
      i
    )

    if aura_data ~= nil then
      if aura_data.spellId == 194249 then
        in_voidform = true
      end
    end
  end

  if in_voidform then
    SendChatMessage(msg, chatType, language)
  else
    SendChatMessage("[Shath'Yar] " .. ShathYar_Translate(msg),
      chatType, language)
  end
end

SLASH_SYSAY1 = "/sy"
SLASH_SYSAY2 = "/sys"
SLASH_SYSAY3 = "/sysay"
SlashCmdList["SYSAY"] = function(msg)
  ShathYar_SendChatMessage(msg, "say")
end

SLASH_SYYELL1 = "/syy"
SLASH_SYYELL2 = "/syyell"
SlashCmdList["SYYELL"] = function(msg)
  ShathYar_SendChatMessage(msg, "yell")
end

SLASH_SYPRINT1 = "/syp"
SLASH_SYPRINT2 = "/syprint"
SlashCmdList["SYPRINT"] = function(msg)
  print(ShathYar_Translate(msg))
end

SLASH_SYGUILD1 = "/syg"
SlashCmdList["SYGUILD"] = function(msg)
  ShathYar_SendChatMessage(msg, "guild")
end
