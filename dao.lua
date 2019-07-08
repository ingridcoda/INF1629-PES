-- load connection file
require("contador")


-- enable contador and assert use
local assert, contador, string = assert, contador, string
local error, type, tostring = error, type, tostring
local require = require
local pairs = pairs
local print = print

--debug
local _G = _G

module("dao")

-- Executes a query in the database specified by
-- the contador.lua file.
-- @param sql statement to be executed
-- @return iterator function containing tuples
local function query(stmt)
  local con = contador.db_connect()
  local res, err = con:execute(stmt)
  con:close()

  assert(res, "\n\nQuery:\n"..stmt.."\n\nErro:\n"..(err or "").."\n")

  -- insert query
  if type(res) == "number" then
    return res
  end

  -- return iterator function
  return function()
     -- "a" uses the database index in the lua table
     return res:fetch({},"a")
  end
end

-- Pré-condição: Arquivo JSON deve existir e ser válido
-- Pós-condição: "lines" é uma tabela que cada índice contém uma linha do arquivo JSON
-- Justificativa: A função "lines_from" retorna uma tabela com as linhas de um arquivo dado.
function get_conferences_json()
  local file = 'jsonConferences.json'
  local lines = lines_from(file)
  return lines
end

-- Pré-condição: Arquivo "file" deve ser passado como parâmetro
-- Pós-condição: "f" contém arquivo válido ou valor "nil"
-- Justificativa: A função testa se o arquivo passado pode ser aberto ou não, 
--                retornando o arquivo em caso positivo ou nulo em caso negativo.
function file_exists(file)
  local io = require("io")
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- Pré-condição: Arquivo "file" deve ser passado como parâmetro e função "file_exists" 
--               deve existir e estar no mesmo módulo .lua
-- Pós-condição: "lines" é uma tabela que cada índice contém uma linha do arquivo ou 
--                está vazia em caso do arquivo não existir
-- Justificativa: A função usa a função "files_exists" para testar se arquivo existe e,
--                caso exista, itera suas linhas e adiciona no "lines". Caso não exista, 
--                "lines" é vazia, retornando seu valor ao final da execução
function lines_from(file)
  local io = require("io")
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- Pré-condição: Arquivo "file" deve ser passado como parâmetro e as funções "file_exists" 
--               e "lines_from" devem existir e estar no mesmo módulo .lua
-- Pós-condição: "lines" é uma tabela que cada índice contém uma linha do arquivo ou 
--                está vazia em caso do arquivo não existir
-- Justificativa: A função verifica existência do arquivo e, caso não exista, retorna uma 
--                tabela vazia, caso contrário, ela obtém as linhas do arquivo e itera sobre
--                elas, verificando seu conteúdo para retornar os parâmetros de cada um dos 
--                objetos JSON de forma concatenada.
function object_from(file)
  local io = require("io")
  if not file_exists(file) then
    return {}
  end
  objects = {}
  objects = lines_from(file)
  result = {}
  i = 1
  j = 1
  while i <= #objects do
    if not string.match(objects[i], "}") and not string.match(objects[i], "%[") and not string.match(objects[i], "%]") then
      if result[j] == nil then
        result[j] = objects[i]
        result[j] = result[j].."<br/>"
      else 
        result[j] = result[j]..objects[i]
        result[j] = result[j].."<br/>"
      end
    else 
      if string.match(objects[i], "}") then
        if result[j] == nil then
          result[j] = "}"
        else 
          result[j] = result[j].."}"
        end
        j = j + 1
      else 
        result[j] = result[j]
      end
    end
   i = i + 1
  end
  return result
end

-- Pré-condição: "conference" deve ser passado como parâmetro e a função "object_from" 
--                deve existir e estar no mesmo módulo .lua
-- Pós-condição: "result" é uma string que contém todo o conteúdo do JSON correspondente 
--                à conferencia passada
-- Justificativa: A função utiliza a função "object_from" para obter os dados em JSON da
--                conferência e retornar seu valor
function get_conference_json(conference)
  local file = 'jsonConferences.json'
  local allConferences = object_from(file)
  local result = nil
  for k,v in pairs(allConferences) do
    if string.match(v, conference) then
      result = v
    end
  end
  return result;
end

-- Pré-condição:  Strings "str" e "separator" devem ser passadas como parâmetro 
-- Pós-condição: "result" é uma tabela que cada índice contém uma parte da string 
--               "str", ou está vazia em caso da string não existir ou o separador
--                não for encontrado
-- Justificativa: A função verifica existência do separador "separator" na string 
--                "str" e, caso não exista, retorna uma tabela vazia, caso contrário, 
--                obtém partes da string e armazena em cada índice, retornando seu valor
function split_string(str, separator)
  local table = require("table")
  result = {}
  for match in (str..separator):gmatch("(.-)"..separator) do
    table.insert(result, match)
  end
  return result
end

-- Pré-condição:  String "conference" deve ser passada como parâmetro 
--                e função "object_from" deve existir e estar no mesmo 
--                módulo .lua
-- Pós-condição: "result" é uma tabela que cada índice contém um paper, 
--                ou está vazia em caso da conferencia não existir 
-- Justificativa: A função verifica existência da conferencia "conference"
--                no arquivo "jsonPapers.json" e, caso não exista, retorna 
--                uma tabela vazia, caso contrário, retorna os papers
function list_papers_by_conference(conference)
  local file = "jsonPapers.json"
  local allPapers = object_from(file)
  local result = {}
  for k,v in pairs(allPapers) do
    if string.match(v, conference) then
      result[#result + 1] = v
    end
  end
  return result
end

-- Pré-condição:  Tabela "obj" deve ser passada como parâmetro e função
--                "split_string" deve existir e estar no mesmo módulo .lua
-- Pós-condição: "c" é uma tabela que cada índice contém um par chave e valor, 
--                ou está vazia em caso de "obj" estar vazia
-- Justificativa: A função realiza a formatação e separação de uma tabela 
--                gerada com dados tipo string em chave e valor. 
function separate_in_key_value(obj)
  local d = obj
  local c = {}
  for k,v in pairs(d) do 
		local e = split_string(v, ":")
		local i = 0
		local keys = {}
    local values = {}  
    local isNumber = false;  
		if #e > 0 then
			for key,value in pairs(e) do
        if i % 2 == 0 then
          if string.match(value, "id") or  string.match(value, "num_downloads") or string.match(value, "num_citations") then
            isNumber = true;
          else
            isNumber = false;
          end
					keys[#keys + 1] = string.sub(value, string.len('  "')+1, (string.len(value) - string.len('" ')))
        else
          if not string.match(string.sub(value, string.len(value), string.len(value)), ',') then
            if isNumber then
              values[#values + 1] = string.sub(value, string.len(' ')+1, string.len(value))
            else
              values[#values + 1] = string.sub(value, string.len(' "')+1, (string.len(value) - string.len('"')))
            end
          else
            if isNumber then
              values[#values + 1] = string.sub(value, string.len(' ')+1, (string.len(value) - string.len(',')))
            else
              values[#values + 1] = string.sub(value, string.len(' "')+1, (string.len(value) - string.len('",')))
            end
          end
				end
				i = i+1
			end
			i = 1
      while i <= #keys and i <= #values do
        if values[i] == nil then
          c[keys[i]] = " "
        else
          c[keys[i]] = values[i]
        end
				i = i+1
			end
		end
  end
  return c
end

-- Query function for retrieving one paper by id.
-- @param paper_id: paper id
-- @return iterator function containing tuples or nil
function get_paper_by_id(paper_id)
  local stmt = "select * from papers where id="..paper_id..";"
  return query(stmt)
end

-- Pré-condição:  função "object_from" deve existir e estar no mesmo módulo .lua
-- Pós-condição: "result" é uma tabela que contém todos os papers
-- Justificativa: A função utiliza a função "object_from" para obter os dados em 
--                JSON do arquivo "jsonPapers.json" e retornar seu valor
function get_all_papers()
  local file = "jsonPapers.json"
  local allPapers = object_from(file)
  local result = {}
  for k,v in pairs(allPapers) do
    result[#result + 1] = v
  end
  return result
end

-- Query function for retrieving 20 papers ordered by date of citations (ASC).
-- @return iterator function containing tuples or nil
function get_papers_by_date_citations(num_papers)
  local stmt = "select * from papers order by date_citations ASC limit "..num_papers..";"
  --local stmt = "SELECT * FROM ( "..
	--			   "SELECT * FROM papers ORDER BY date_citations ASC "..
		--		") AS t1 "..
			--	"GROUP BY file_name ORDER BY date_citations ASC LIMIT " .. num_papers..";"
  return query(stmt)
end
--Get paper with last citation date
function get_last_citation_paper()
  local stmt = "select * from papers order by date_citations DESC limit 1;"
  return query(stmt)
end

-- Pré-condição:  função "object_from" deve existir e estar no mesmo módulo .lua
-- Pós-condição: "result" é uma tabela que contém todos os papers mais citados
-- Justificativa: A função utiliza a função "object_from" para obter os dados em 
--                JSON do arquivo "jsonMostCited.json" e retornar seu valor
function get_papers_most_cited()
  local file = "jsonMostCited.json"
  local mostCitedPapers = object_from(file)
  local result = {}
  for k,v in pairs(mostCitedPapers) do
    result[#result + 1] = v
  end
  return result
end

function insert_conference(c)
  local stmt = string.format("insert into conferences (name_conference, url,"
  .."editor, ISBN, month, days, year, country, city) VALUES ('%s','%s','%s',"
  .."'%s','%s','%s','%s','%s','%s')", c.name, c.url, c.editor, c.isbn,
  c.month, c.days, c.year, c.country, c.city)

--  return stmt
  return query(stmt)
end

function insert_paper(p)
  local stmt = string.format("insert into papers (paper_title, file_name,"
  .."key_words, language,author, add_author, abstract, paper_session, page,"
  .."name_conference) VALUES ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')",
  p.paper_title, p.file_name, p.key_words, p.language, p.author, p.add_author,
  p.abstract, p.paper_session, p.page, p.conference)

--  return stmt
  return query(stmt)
end
--]]


function get_downloads_number(file_name)
	local stmt = string.format("SELECT * FROM `papers` WHERE `file_name` = '%s'", file_name)
	return query(stmt)
end

function add_download(file_name)
	local stmt = string.format("UPDATE papers SET num_downloads = num_downloads + 1 WHERE file_name = '%s'", file_name)
	return query(stmt)
end

-- function add_citation(file_name, num_citations)
		-- local stmt = string.format("UPDATE papers SET num_citations = "..num_citations.." , date_citations = CURRENT_TIMESTAMP WHERE file_name = '%s'", file_name)
		-- return query(stmt)
-- end