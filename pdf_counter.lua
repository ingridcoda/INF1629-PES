-- load config and manager
local cfg = dofile"config.lua"
dofile"file_manager.lua"
dofile"dao.lua"
  
-- get file_name
local conference = cgilua.QUERY.wtrans
-- wtrans, em query.wtrans, equivale a antigo conference no php --  
local file_name = cgilua.QUERY.file_name

if not conference or not file_name or cfg[paper_folder] then error() end

-- increment file counter
local res = dao.add_download(file_name)
--manager.update_file_counter(conference.."/"..file_name)

-- open file
local file_path = cfg["paper_folder"]..conference.."/"..file_name
local file = io.open(file_path, 'r')
if not file then error(file_path.." does not exist.") end

-- send file
cgilua.contentheader("aplication", "octect-stream")
cgilua.header('Content-Disposition: filename="'..file_name..'\n"', "")
cgilua.put(file:read ("*a"))

-- close file
file:close()

