local clock = require 'clock'
local b58 = require 'base58'
local uuid = require 'uuid'
local digest = require 'digest'

local M = {}

function M:id()
	return self.prefix .. b58.encode( digest.urandom(self.size) )
end

function M:new(t)
	t = t or {}
	return setmetatable({
		size = t.size or 16;
		prefix = t.prefix or '';
	}, { __index = self })
end


--[[
--bench

local gen = M:new{ prefix = 'P'; }
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
