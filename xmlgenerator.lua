require('dao')

local assert, dao, string = assert, dao, string
local error, type, tostring = error, type, tostring
local require = require
local pairs = pairs
local print = print

--debug
local _G = _G

module("xmlgenerator")

-- Pré-condição:  string "conferenceName" deve ser passada como parâmetro
-- Pós-condição: "xmlcontent" é uma string que contém os dados da conferência 
--                selecionada no formato xml solicitado
-- Justificativa: A função realiza a formatação dos dados da conferência e 
--                armazena em "xmlcontent", retornando seu valor.
function generateXML(conferenceName)
    local xmlcontent = '<?xml version="1.0" encoding="UTF-8" ?>    <!DOCTYPE dblpsubmission SYSTEM "dblpsubmission.dtd">    <?xml-stylesheet type="text/xsl" href="dblpsubmission.xsl" ?>    <dblpsubmission>    <proceedings>    <key>WTranS</key>'
    
    local editors = {}
    local title = '<title>Anais do '..conferenceName..' - Workshop de Transparência em Sistemas</title>'
    local publisher = '<publisher>Editora PUC-Rio</publisher>' -- não tem esse dado no banco, consequentemente não tem nos json
    local year = ''
    local acronym = ''
    local number = ''
    local location = ''
    local date = ''
    local url = ''

    local publ = {}
    local authors = {}
    local titlePubl = ''
    local ee = ''

    local conferenceData = dao.get_conference_json(conferenceName)
    local conferencePapersData = dao.list_papers_by_conference(conferenceName)
    
    if conferenceData == nil or conferencePapersData == nil then
        return ""
    end
    
	local x = dao.split_string(conferenceData, "<br/>")
    local p = dao.separate_in_key_value(x)
    local t = dao.split_string(p["editor"], ",")
    for k1, v1 in pairs(t) do
        editors[#editors + 1] = '<editor>'..v1..'</editor>'
    end
    year = '<year>'..p["year"]..'</year>'    
    acronym = '<acronym>WTranS '..p["year"]..'</acronym>'
    number = '<number>'..p["id"]..'</number>'
    location = '<location>'..p["city"]..', '..p["country"]..'</location>'
    date = '<date>'..p["days"]..' de '..p["month"]..' de '..p["year"]..'</date>'
    url = '<url>http://wtrans.inf.puc-rio.br/WTRANSartigos/papers_by_conference.lp?conference='..p["name_conference"]..'</url>'
    

    local i = 1
    for k, v in pairs(conferencePapersData) do
        local x = dao.split_string(v, "<br/>")
        local p = dao.separate_in_key_value(x)
        authors[#authors + 1] = '<author>'..p["author"]..'</author>'
        local t = dao.split_string(p["add_author"], ",")
        for k1, v1 in pairs(t) do
            authors[#authors + 1] = '<author>'..v1..'</author>'
        end
        titlePubl = '<title>'..p["paper_title"]..'</title>'
        ee = '<ee>http://wtrans.inf.puc-rio.br/WTRANSartigos/artigos/artigos_'..p["name_conference"]..'/'..p["file_name"]..'</ee>'
        local index = #publ + i;
        for k2, v2 in pairs(authors) do
            if publ[index] == nil then
                publ[index] = "<publ>"..v2
            else
                publ[index] = publ[index]..v2
            end
        end

        authors = {}

        if publ[index] == nil then
            publ[index] = titlePubl
        else
            publ[index] = publ[index]..titlePubl
        end

        if publ[index] == nil then
            publ[index] = ee
        else            
            publ[index] = publ[index]..ee
        end

        publ[index] = publ[index]..'</publ>'

        i = i + 1
    end

    for k,v in pairs(editors) do
        xmlcontent = xmlcontent..v
    end

    xmlcontent = xmlcontent..title
    xmlcontent = xmlcontent..publisher
    xmlcontent = xmlcontent..year
    xmlcontent = xmlcontent..'<conf>'
    xmlcontent = xmlcontent..acronym
    xmlcontent = xmlcontent..number
    xmlcontent = xmlcontent..location
    xmlcontent = xmlcontent..date
    xmlcontent = xmlcontent..url
    xmlcontent = xmlcontent..'</conf>    <toc>'
    
    for k,v in pairs(publ) do    
        xmlcontent = xmlcontent..v
    end
    
    xmlcontent = xmlcontent..'</toc>    </proceedings>    </dblpsubmission>'

    return xmlcontent, publ
end

-- Pré-condição:  string "conferenceName" deve ser passada como parâmetro e função "generateXML"
--                deve existir e estar no mesmo módulo .lua
-- Pós-condição:  a função "generateXML" gerou os dados da conferência selecionada no formato
--                XML solicitado e um arquivo foi salvo na pasta dblp com esses dados
-- Justificativa: A função realiza a criação de um arquivo xml e o preenche com os dados contidos
--                na string "xmlcontent", gerada pela função "generateXML".
function createXML(conferenceName)
    local xmlcontent, publ = generateXML(conferenceName)    
    local io = require("io")
    file, err = io.open("dblp/"..conferenceName..".xml", "wb+")
    if file ~= nil then
        file:write(xmlcontent)
        file:close()
    else
        return err
    end
end