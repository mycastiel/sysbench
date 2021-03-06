#!/usr/bin/env sysbench
-- Copyright (C) 2006-2017 Alexey Kopytov <akopytov@gmail.com>

-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

-- ----------------------------------------------------------------------
-- Insert-Only OLTP benchmark
-- ----------------------------------------------------------------------

require("oltp_common")

sysbench.cmdline.commands.prepare = {
   function ()
      if (not sysbench.opt.auto_inc) then
         -- Create empty tables on prepare when --auto-inc is off, since IDs
         -- generated on prepare may collide later with values generated by
         -- sysbench.rand.unique()
         sysbench.opt.table_size=0
      end

      cmd_prepare()
   end,
   sysbench.cmdline.PARALLEL_COMMAND
}

function prepare_statements()
   -- We do not use prepared statements here, but oltp_common.sh expects this
   -- function to be defined
end

function event()
   local table_name = "sbtest" .. sysbench.rand.uniform(1, sysbench.opt.tables)
   local k = sysbench.rand.default(1,sysbench.opt.table_size)
   local k1 = sysbench.rand.default(1,sysbench.opt.table_size)
   local k2 = sysbench.rand.default(1,sysbench.opt.table_size)
   local k3 = sysbench.rand.default(1,sysbench.opt.table_size)
   local k4 = sysbench.rand.default(1,sysbench.opt.table_size)
   local k5 = sysbench.rand.default(1,sysbench.opt.table_size)
   local k6 = sysbench.rand.default(1,sysbench.opt.table_size)
   local k7 = sysbench.rand.default(1,sysbench.opt.table_size)
   local k8 = sysbench.rand.default(1,sysbench.opt.table_size)
   local c_val = get_c_value()
   local pad_val = get_pad_value()

   if (drv:name() == "pgsql" and sysbench.opt.auto_inc) then
      con:query(string.format("INSERT INTO %s (k, c, pad) VALUES " ..
                                 "(%d, '%s', '%s')",
                              table_name, k_val, c_val, pad_val))
   else
      if (sysbench.opt.auto_inc) then
         i = 0
      else
         -- Convert a uint32_t value to SQL INT
         i = sysbench.rand.unique() - 2147483648
      end

      con:query(string.format("INSERT INTO sbtest%u (id, k, k1, k2, k3, k4, k5, k6) VALUES " ..
                                 "(%d,  %d, %d, %d, %d, %d,  %d, %d)",
                              table_name, i, k, k1, k2, k3, k4, k5, k6))
   end

   check_reconnect()
end
