# A collection of id generation methods

## Snowflake

[Twitter's snowflake](https://github.com/twitter/snowflake/)

> Node varies from 0 to 32
> Datacenter varies from 0 to 32

```lua
local sfl = require 'id.snowflake'
local gen = sfl:new{ node = 1; datacenter = 2; }

local id = gen:id()
...
```

```
621246523426082816ULL
```

## DSG (Distributed Sequence Generator): Simplified version of Snowflake

Algorithm taken from article "[Generating unique IDs in a distributed environment at high scale](https://www.callicoder.com/distributed-unique-id-sequence-number-generator/)"

> Node varies from 0 to 1023  

```lua
local dsg = require 'id.dsg'
local gen = dsg:new{ node = 1; }

local id = gen:id()
...
```

```
595018701653151744ULL
```

## ULID

Implementaion of [ULID](https://github.com/ulid/spec)

```lua
local ulid = require 'id.ulid'
local gen = ulid:new()

local id = gen:id()
...
```

```
01DEN8879B47JBKVCJBW7DV3F8
```

## Icecap

Something between snowflake and ulid (It looks like ulid, and made from 50 bits of time, 10 bits of node id and 60 bits of random)

```lua
local icecap = require 'id.icecap'
local gen = icecap:new{node = 1}

local id = gen:id()
...
```

```
01DFTJ1B3E01Y9HRTHDAFZY3
```

## Base 58 UUID

(Requires [base58](https://github.com/moonlibs/base58) library)

```lua
local uuid58 = require 'id.uuid58'
local gen = uuid58:new()

local id = gen:id()
...
```

```
4fuuF9Mg7DfsgQU8sTneQw
```

May be customized with prefix


```lua
local uuid58 = require 'id.uuid58'
local gen = uuid58:new{ prefix = 'P' }

local id = gen:id()
...
```

```
P3SdUvhcfLjMHbsG8naW9gB
```

## Base 58 Random

(Requires [base58](https://github.com/moonlibs/base58) library)

```lua
local r58 = require 'id.r58'
local gen = r58:new()

local id = gen:id()
...
```

```
vfcxxHeBxp7XatJcrXyCpA
```

May be customized with prefix and size (in bytes)

```lua
local r58 = require 'id.r58'
local gen = r58:new{ prefix = 'P'; size = 32 }

local id = gen:id()
...
```

```
PhtfB6SYWK4L5H9KJwJR6QnJpPye1XZftmBirYu8inmL
```
