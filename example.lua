local dsg = require 'id.dsg'
local sfl = require 'id.snowflake'
local ulid = require 'id.ulid'
local icecap = require 'id.icecap'

-- this ones requires base58
local r58 = require 'id.r58'
local u58 = require 'id.uuid58'

print( "DSG:        ", dsg:new{ node = 1; }:id() )
print( "Snowflake:  ", sfl:new{ node = 1; datacenter = 2; }:id() )
print( "ULID:       ", ulid:new():id() )
print( "Icecap:     ", icecap:new{ node = 1; }:id() )

print( "R58:        ", r58:new():id() )
print( "R58+prefix: ", r58:new{prefix = 'P';size=15}:id() )
print( "R58+prefix: ", r58:new{prefix = 'P';size=32}:id() )

print( "UUID58:     ", u58:new():id() )
print( "UUID58+P:   ", u58:new{prefix = 'P';}:id() )
