select distinct schemaname
from (
  select creator from sysibm.systables
  union all
  select schema from sysibm.sysdatatypes
  union all
  select schema from sysibm.sysroutines
  union all
  select schema from sysibm.systriggers
) schemata(schemaname)
