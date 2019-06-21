<%
  local cfg = dofile"config.lua"
%>
<html>
<head>
   <title>WTranS - Workshop de Transpar�ncia em Sistemas</title>
</head>

<body>
  <br>
  <table width="100%">
    <tr>
      <%
        cgilua.print('<p align="center"><img border="0" src="'..
        cfg.image_folder..'/logo_wtrans_new.jpg" width="169" height="102"></p>')
      %>
      <p align="center">
        <font face="Times New Roman" size="5" color="#0000FF">
          Workshop de Transpar�ncia em Sistemas
        </font>
        <br>
        <font face="Times New Roman" size="4" color="gray">
          Workshop de Transpar�ncia em Sistemas<br>          
        </font>
      </p>
    </tr>
    <br>
    <tr>
      <p align="justify" style="margin-left: 10%; margin-right: 10%">
        <font face="Arial">---------------------
        </font>
        </br></br>
        
      </p>
      <p style="margin-left: 10%; margin-right: 10%" align="center"><b>
        <font face="Verdana" size="2">
          <%
            -- list all wtrans conferences homepages
            dofile"dao.lua" -- use dao to access the database
            conferences = dao.get_conferences_json()
            for v in conferences do
			   if v.url:match("http") then
			      cgilua.print('<a href="'..v.url..'">'..v.name_conference..
                  '</a>&nbsp;&nbsp;\n')
			   else
                  cgilua.print('<a href="http://'..v.url..'">'..v.name_conference..
                  '</a>&nbsp;&nbsp;\n')
			   end
            end
          %>       
          <i>!new!</i>&nbsp;&nbsp;
        </font></b>
      </p>
	  </tr>
   </table>
	<table align="center" width="50%">
		<% dofile"google_search_box.lua" %>
	<table>
</body>

<footer>
  <% dofile"footer.lua" %>
</footer>
</html>
