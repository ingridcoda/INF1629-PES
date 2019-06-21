package.path = "/opt/kepler/share/lua/5.1/?.lua;" .. package.path
package.cpath = "/opt/kepler/lib/lua/5.1/?.so;" .. package.cpath
package.path = "/home/b/wtrans/public_html/WTRANSartigos/?.lua;"..package.path
package.path = "/home/b/wtrans/public_html/WTRANSartigos/scholar/?.lua;"..package.path

local c = require("scholar_core")
c.generate_cited()
c.verify_output()

