-- enable dofile, io and pairs use
local assert, dofile,io,pairs = assert, dofile,io,pairs

-- load "file_counter" name
local counter_file = (dofile"config.lua").file_counter_data

--debug local _G = _G

module("manager")

-- Persist a table in the counter_file.
-- Do not use optimized table creation.
-- @params tab: table to persist
local function persist_table (tab)
  local h = assert(io.open(counter_file,"w"))
  h:write("return {\n")
  for k,v in pairs(tab) do
    h:write('["'..k..'"] = '..v..",\n")
  end
  h:write("}\n")
  h:close()
end

-- Incrments the file "download counter"
-- Entry directives garantee file_name and counter table
-- @param file_name: name of downloaded file
function update_file_counter(file_name)
  -- loads counter table
  local counter_table = dofile(counter_file)
  -- add 1 to paper counter
  if counter_table[file_name] then
    counter_table[file_name] = counter_table[file_name] + 1
  else
    counter_table[file_name] = 1
  end
  -- persist table
  persist_table(counter_table)
end