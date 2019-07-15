local clock = require 'clock'
local ffi = require 'ffi'
local digest = require 'digest'

local ENCODING = {
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "M",
  "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"
}
local ENCODING_LEN = #ENCODING
local MAX_NODE = 1024

local clck = clock.realtime64
local function timestamp()
	return clck()/1e6
end

local M = {}

local C = ffi.C
if not pcall(function(C) return C.random end,C) then
	ffi.cdef[[ long random(void); ]]
end
local function random32()
	return C.random()
end

local concat = table.concat

function M:id()
	local val = timestamp()
	if val < self.last then
		error("Clock goes backward")
	end
	self.last = val
	local res = {}

	for i = 10,1,-1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	val = self.node
	for i = 12, 11, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end

	val = random32()
	for i = 16, 13, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	val = random32()
	for i = 20, 17, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	val = random32()
	for i = 24, 21, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	return concat(res)
end

function M:new(t)
	if not t.node then error("Node id required",2) end
	if t.node < 0 or t.node >= MAX_NODE then
		error(("Node id %s doesn't fit into [%s..%s]"):format(t.node,0,MAX_NODE-1),2)
	end
	return setmetatable({
		node = t.node;
		last = 0LL;
	}, { __index = self })
end

--[[
--bench

local gen = M:new{ node = 1 }

print(gen:id())

local st = clock.proc()
local N = 1e5
for i=1,N do
	local x = gen:id()
end
local run = clock.proc() - st

print(("%d / %0.2fs = %s"):format( N,run, N/run  ))

]]

return M
