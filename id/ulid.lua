local clock = require 'clock'
local ffi = require 'ffi'
local digest = require 'digest'

local ENCODING = {
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "M",
  "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"
}
local ENCODING_LEN = #ENCODING
local TIME_LEN = 10
local RANDOM_LEN = 16

local clck = clock.realtime64
local function timestamp()
	return clck()/1e6
end


local M = {}

local function random64()
	local data = digest.urandom(8)
	return ffi.cast("uint64_t *",data)[0]
end

local C = ffi.C
if not pcall(function(C) return C.random end,C) then
	ffi.cdef[[ long random(void); ]]
end
local function random32()
	return C.random()
end

local concat = table.concat

function M:id32()
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
	
	val = random32()
	for i = 14, 11, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end

	val = random32()
	for i = 18, 15, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	val = random32()
	for i = 22, 19, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	val = random32()
	for i = 26, 23, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	return concat(res)
end

function M:id64()
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
	val = random64()
	for i = 18, 11, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	val = random64()
	for i = 26, 19, -1 do
		local mod = tonumber(val % ENCODING_LEN)
		res[i] = ENCODING[mod + 1]
		val = (val - mod) / ENCODING_LEN
	end
	
	return concat(res)
end

M.id = M.id32

function M:new(t)
	return setmetatable({
		last = 0LL;
	}, { __index = self })
end

--[[
--bench

local gen = M:new{}

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
