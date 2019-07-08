<%
  dofile"dao.lua"
  local cfg = dofile"config.lua"
  counter_table = dofile(cfg.file_counter_data)
  local c = dao.get_conference_json(cgilua.QUERY.conference)
%>
<html>
<head>
<title>
<%cgilua.print(string.format("%s %s: %s, %s",
  c.name_conference, c.year, c.city, c.country))
%>
</title>
</head>

<body>
  <h1>
    <%cgilua.print(string.format(
      "<a href=http://%s>%s</a> - Workshop de Transpar�ncia em Sistemas %s: %s, %s",
        'wtrans.inf.puc-rio.br', c.name_conference, c.year, c.city, c.country))
    %>
  </h1>
  <hr>
  <%
    local anais_string = string.format("Anais do %s - Workshop de Transpar�ncia "
      .."em Sistemas, %s, %s, %s %s, %s", c.name_conference, c.city,
      c.country, c.month, c.days, c.year, c.ISBN, c.year)

    cgilua.print(string.format("%s (Ed.): "..anais_string..".<p align=right><a href='"..cfg["file_paper_home"].."' align=right>voltar</a><p>", c.editor))

    cgilua.print(string.format(
      "<pre>@proceedings{<a href='"..cfg["file_wtrans_home"].."'>WTRANSArtigos</a>: %s,<br>&nbsp;&nbsp;"
        .."editor = {%s},<br>&nbsp;&nbsp;"
        .."title = {"..anais_string.."},<br>&nbsp;&nbsp;"
        .."publisher = { },<br>&nbsp;&nbsp;"
        .."ISBN = {%s},<br>&nbsp;&nbsp;"
        .."year = {%s}<br>"
      .."}<br></pre>", c.name_conference, c.editor, c.ISBN, c.year))

    local gpapers = dao.list_papers_by_conference(cgilua.QUERY.conference)
    local i = 1
    old_paper_session = ""
    for p in gpapers do
      -- print session if it changed
      if p.paper_session ~= old_paper_session then
        cgilua.print("<H2>"..p.paper_session.."</H2>")
        old_paper_session = p.paper_session
      end
	  
      local scholar_url = require"scholar/scholar_string_cleaner".montaUrl(
                                  cfg.scholar_base_url, p.paper_title, p.author)
      
      -- print each paper published
      cgilua.print(string.format(
        "<p style='margin-left: 10'><font face='Arial'>%s - <b>%s</b>. <i>%s,"
        .." %s. </i>"..anais_string..", pp %s. <b><a href='%s?wtrans=%s&file_name"
        .."=%s' target='_blank'>[pdf]</a> <a href='%s' target='_blank'>"
        .."[scholar]</a> Downloads: %s</b></font></p> <p align='justify'"
        .."style='margin-left: 30'><font face='Arial' size='2'><b>Abstract: "
        .."</b> %s</font></p></table>", i, p.paper_title, p.author,
        p.add_author, p.page, cfg["file_counter"], p.name_conference,
        p.file_name, scholar_url, counter_table[p.name_conference.."/"
        ..p.file_name] or 0, p.abstract or ""
      ))
      i = i + 1
    end
  %>
  &nbsp;&nbsp;<a href="<%=cfg["file_paper_home"]%>">voltar</a>
</body>
</html>
