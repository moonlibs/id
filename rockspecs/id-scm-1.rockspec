package = 'id'
version = 'scm-1'
source  = {
    url    = 'git://github.com/moonlibs/id.git',
    branch = 'master',
}
description = {
    summary  = "Package for creating ids",
    homepage = 'https://github.com/moonlibs/id',
    license  = 'BSD',
}
dependencies = {
    'lua ~> 5.1'
}
build = {
    type = 'builtin',
    modules = {
        ['id.snowflake'] = 'id/snowflake.lua';
        ['id.dsg']       = 'id/dsg.lua';
        ['id.ulid']      = 'id/ulid.lua';
        ['id.uuid58']    = 'id/uuid58.lua';
        ['id.r58']       = 'id/r58.lua';
    };
}

-- vim: syntax=lua
