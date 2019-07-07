require('dao')

local assert, dao, string = assert, dao, string
local error, type, tostring = error, type, tostring
local require = require
local pairs = pairs
local print = print

--debug
local _G = _G

module("xmlgenerator")

function generateXML(conferenceName)
    local xmlcontent = '<?xml version="1.0" encoding="UTF-8" ?>    <!DOCTYPE dblpsubmission SYSTEM "dblpsubmission.dtd">    <?xml-stylesheet type="text/xsl" href="dblpsubmission.xsl" ?>    <dblpsubmission>    <proceedings>    <key>WTranS</key>'
    
    local editors = {}
    local title = '<title>Anais do '..conferenceName..' - Workshop de Transparência em Sistemas</title>'
    local publisher = '<publisher>Editora PUC-Rio</publisher>' -- não tem esse dado no banco, consequentemente não tem nos json
    local year = ''
    local acronym = '<acronym>'..conferenceName..'</acronym>'
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
    
    --for k, v in pairs(conferenceData) do
		local x = dao.split_string(conferenceData, "<br/>")
        local p = dao.separate_in_key_value(x)
        local t = dao.split_string(p["editor"], ",")
        for k1, v1 in pairs(t) do
            editors[#editors + 1] = '<editor>'..v1..'</editor>'
        end
        year = '<year>'..p["year"]..'</year>'    
        
        number = '<number>'..p["id"]..'</number>'
        location = '<location>'..p["city"]..', '..p["country"]..'</location>'
        date = '<date>'..p["days"]..' de '..p["month"]..' de '..p["year"]..'</date>'
        url = '<url>http://wtrans.inf.puc-rio.br/WTRANSartigos/papers_by_conference.lp?conference='..p["name_conference"]..'</url>'
    --end

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
        for k2, v2 in pairs(authors) do
            if publ[#publ + i] == nil then
                publ[#publ + i] = v2
            else
                publ[#publ + i] = publ[#publ + i]..v2
            end
        end

        if publ[#publ + i] == nil then
            publ[#publ + i] = titlePubl
        else
            publ[#publ + i] = publ[#publ + i]..titlePubl
        end

        if publ[#publ + i] == nil then
            publ[#publ + i] = ee
        else            
            publ[#publ + i] = publ[#publ + i]..ee
        end

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
        xmlcontent = xmlcontent..'<publ>'        
        xmlcontent = xmlcontent..v
        xmlcontent = xmlcontent..'</publ>'
    end
    
    xmlcontent = xmlcontent..'</toc>    </proceedings>    </dblpsubmission>'

    return xmlcontent
end

function createXML(conferenceName)
    local xmlcontent = generateXML(conferenceName)    
    local io = require("io")
    --file = io.open(conferenceName..".xml", "wb+")
    file = io.open("AAAAAAAAAAAAA.xml", "wb+")
    if file ~= nil then
        file:write(xmlcontent)
        file:close()
    end
end