local clock = require 'clock'

local TOTAL_BITS = 64
local EPOCH_BITS = 42
local SITE_BITS  = 5
local NODE_BITS  = 5
local SEQ_BITS   = 12

local MAX_SEQ = 2^SEQ_BITS

local MAX_SITE = 2^SITE_BITS
local MAX_NODE = 2^NODE_BITS

local CUSTOM_EPOCH = 1413817200000ULL -- (2014-10-20T15:00:00Z)

local TIME_SHIFT = TOTAL_BITS - EPOCH_BITS
local SITE_SHIFT = TOTAL_BITS - EPOCH_BITS - SITE_BITS
local NODE_SHIFT = TOTAL_BITS - EPOCH_BITS - SITE_BITS - NODE_BITS

local M = {}

local clck = clock.realtime64

local function timestamp()
	return clck()/1e6 - CUSTOM_EPOCH
end

function M:id()
	local now = timestamp()
	if now < self.last then
		error("Clock goes backward")
	end
	if now == self.last then
		self.seq = ( self.seq + 1 ) % MAX_SEQ
		if self.seq == 0 then
			repeat
				now = timestamp()
			until now > self.last
		end
	else
		self.seq = 0
	end
	self.last = now
	local id = bit.lshift(now, TIME_SHIFT)
	id = bit.bor(id, bit.lshift(self.node, SITE_SHIFT))
	id = bit.bor(id, bit.lshift(self.node, NODE_SHIFT))
	id = bit.bor(id, self.seq)
	return id
end

function M:new(t)
	local site = t.site or t.datacenter
	if not site then error("Datacenter id required",2) end
	if not t.node then error("Node id required",2) end
	if t.node < 0 or t.node >= MAX_NODE then
		error(("Node id %s doesn't fit into [%s..%s]"):format(t.node,0,MAX_NODE-1),2)
	end
	if site < 0 or site >= MAX_NODE then
		error(("Datacenter id %s doesn't fit into [%s..%s]"):format(site,0,MAX_NODE-1),2)
	end
	return setmetatable({
		node = t.node;
		site = site;
		last = 0LL;
	}, { __index = self })
end

-- local gen = M:new{
-- 	site = 1;
-- 	node = MAX_NODE-1
-- }
-- print( gen:id() )

--[[
--bench

local gen = M:new{ node = 1 }
local st = clock.proc()
local N = 1e6
for i=1,N do
	local x = gen:id()
end
local run = clock.proc() - st
print(("%d / %0.2fs = %s"):format( N,run, N/run  ))


]]

return M
