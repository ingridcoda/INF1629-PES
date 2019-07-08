local cfg = dofile"config.lua"
local count_citations = require"scholar/scholar_count_citations"
local scleaner = require"scholar/scholar_string_cleaner"
dofile"dao.lua"

--teste
local function search_citations(texto)
	local exp_reg_citacoes = "Citado por%s+%d+"		 -- Citado por 3

-- IDENTIFICAR Numero Citações
	local delim_ini_cit, delim_fim_cit = string.find(texto, exp_reg_citacoes)  	-- find a space character followed by "s or :"
	if (delim_ini_cit ~= nil and delim_fim_cit ~= nil) then
		texto = string.sub(texto, delim_ini_cit, delim_fim_cit)
		-- Identificar Numero
		local delim_ini_num, delim_fim_num = string.find(texto, "%d+")  		-- find a space character followed by "s or :"
		if (delim_ini_num ~= nil and delim_fim_num ~= nil) then
			local content = string.sub(texto, delim_ini_num, delim_fim_num)
			return tonumber(content)
		else
			return 0
		end
	end
	return 0
end

--EXECUTA UM COMANDO NO SISTEMA OPERACIONAL
function exec_silent(command)
	local p = assert(io.popen(command))
	local result = p:read("*all")
	p:close()
	return result
end

--teste
function get_citations_paper_scholar_copy()
	local tmp_dir = cfg.temporal_files_dir
	-- baixar o rsultado da busca (HTML) no google escholar no dir "file_tmp"
	local result_file_name = 'desafios_result.html'
	local cmd_exec = 'wget -e robots=off -H --user-agent=\"Mozilla\/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko\/2008092416 Firefox\/3.0.3\"  \"http:\/\/scholar.google.com.br/scholar?as_q=desafios para a governança eletrônica e dados governamentais abertos em governos locais autor:vaz\" -O '..tmp_dir..result_file_name
	-- EXECUTA WGET
	exec_silent(cmd_exec)

	-- limpar o HTML e deixar só o numero de citações
	local file_result = io.open(tmp_dir..result_file_name, "r") -- r read mode and b binary mode
	if not file_result then 
		print('Error')
	else
		local content = file_result:read "*a" -- *a or *all reads the whole file
		content = search_citations(content)
		file_result:close()
		file_result = io.open(tmp_dir..result_file_name, "w")
		file_result:write("")
		
		file_result:write(content)
		file_result:close()
		print(content)
	end
end

--atualiza o numero de citacoes dos papers uma vez x dia
--lista os papers menos atualizados
--filtra os recentemente atualizados
--lista 20 no máximo
function get_citations_paper_scholar()
	local tmp_dir = cfg.temporal_files_dir
	
	--pegar paper com ultima data de atualizacao de citacoes
	local last_citation_paper = dao.get_last_citation_paper()
	--pegar data de hoje
	local now = os.date("%Y-%m-%d")
	local same_date = false
	local last_citation_date = ''
	for p in last_citation_paper do
		last_citation_date = string.sub(p.date_citations, 1, 10)
	end
		
	if last_citation_date == now then
		same_date = true
	end
	--atualizar somente uma vez por dia
	if not same_date then	
		--pegar os papers atualizados por data em ordem ascendente
		local gpapers = dao.get_papers_by_date_citations(20)
		for p in gpapers do
			local scholar_url = scleaner.montaUrl(cfg.scholar_base_url, p.paper_title, p.author)
			-- baixar o rsultado da busca no google escholar no dir "file_tmp"
			local result_file_name = p.file_name..'.result'
			--local cmd_exec = 'wget -e robots=off -H --user-agent=\"Mozilla\/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko\/2008092416 Firefox\/3.0.3\"  \"http:\/\/scholar.google.com.br/scholar?as_q=desafios para a governança eletrônica e dados governamentais abertos em governos locais autor:vaz\" -O '..tmp_dir..result_file_name
			--local cmd_exec = 'wget -e robots=off -H --user-agent=\"Mozilla\/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko\/2008092416 Firefox\/3.0.3\" \"' .. scholar_url .. '\" -O '..tmp_dir..result_file_name
			--local cmd_exec = 'wget -e robots=off -H --user-agent=\"Mozilla\/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko\/2008092416 Firefox\/3.0.3\" \"' .. scholar_url .. '\" -O '..tmp_dir..result_file_name
			local cmd_exec = 'wget '.. ' -O '..tmp_dir..result_file_name .. ' -e robots=off -H --user-agent=\"Mozilla\/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko\/2008092416 Firefox\/3.0.3\" ' .. scholar_url 
			
			exec_silent(cmd_exec)

			-- limpar o HTML e deixar só o numero de citações
			local file_result = io.open(tmp_dir..result_file_name, "r") -- r read mode and b binary mode
			if not file_result then 
				print('Error')
			else
				local pagina = file_result:read "*a" -- *a or *all reads the whole file
				
				local citations = count_citations(pagina, p.paper_title)
			
				file_result:close()
				file_result = io.open(tmp_dir..result_file_name, "w")
				file_result:write("")
				
				file_result:write(citations)
				file_result:close()
				
				-- --atualizar no banco
				-- local res = dao.add_citation(p.file_name, citations)
				
			end
		end	
	end
	return {}
end
	
return {
	get_citations_paper_scholar()
}
