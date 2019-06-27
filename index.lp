<%
  local cfg = dofile"config.lua"
  local limit = cfg.file_most_cited_limit
  
  --ATUALIZAR O NUMERO DE CITACOES DO PAPER (20 ULTIMOS ATUALIZADOS) 1 VEZ X DIA
	-- local update_most_cited = dofile(cfg.file_most_cited)
%>
<html>
<head>
   <title>WTranSartigos - Artigos Publicados no Workshop de Transparência em Sistemas</title>
   <meta charset="unicode"/>
</head>

<body>
<br>
   <table border="0" cellpadding="0" cellspacing="0" style="border-collapse:
     collapse" bordercolor="#111111" width="100%" id="AutoNumber1">
      <tr>
      <td>
         <% 
            cgilua.print('<p align="center"><img border="0" src="logo_wtrans_papers.jpg" width="300"'
              ..'height="110"></p>')
         %>
         <p align="center">
            <font face="Times New Roman" size="5" color="#0000FF">Artigos
              publicados no WTranS</font>
            </br>
            <font face="Times New Roman" size="4" color="gray">
              Artículos publicados en WTranS</br>Papers published on WTranS
            </font>
         </p>
      <br>
      </td>
      </tr>
      <tr>
      <td>
         <p align="justify" style="margin-left: 10%; margin-right: 10%">
            <font face="Arial">WTranSArtigos disponibiliza os artigos publicados
              nos anais de cada <%cgilua.print('<a href="'..cfg.file_wtrans_home
              ..'" target="_blank">WTranS</a>')%>.  O acesso pode ser feito pelo
              sumário dos anais (para cada edição) ou por busca livre
              utilizando-se a máquina de busca Google (para todas as edições).
              A busca Google é livre e acessa os artigos em pdf.
            </font>
            </br></br>
            <font face="Arial" color="gray">WTranSArtigos pone a su disposición
              los artículos publicados en los anales de todos los Workshops
              <%cgilua.print('<a href="'..cfg.file_wtrans_home..'" target='..
              '"_blank">WTranS</a>')%>. Es posible acceder a los mismos utilizando
              el resumen de los anales (para cada edición) o mediante el motor
              de búsqueda Google (para todas las ediciones). La búsqueda en
              Google permited acceder a los artículos en formato pdf.
              </br></br>
              WTranSArtigos makes it possible to access <%cgilua.print('<a href="'
              ..cfg.file_wtrans_home..'" target="_blank">WTranS</a>')%> published
              papers. The access can be done for each edition or by using the
              Google search engine. Google searches pdf files in all WTranS
              editions.
            </font>
         </p>
         <p style="margin-left: 10%; margin-right: 10%" align="center"><b>
            <font face="Verdana" size="2">
              <%
			    dofile"dao.lua"
				--list all papers link
				cgilua.print('<a href='..cfg.file_all_papers..'>'..'Todos os Papers | Todos los Papers | All Papers' ..'</a>&nbsp;&nbsp;</br>')
				  
                -- list all wtrans conferences using dao to access the json file
                conferences = dao.get_conferences_json()
                confs = {"WTRANS13", "WTRANS14", "WTRANS15", "WTRANS16", "WTRANS17", "WTRANS18"}
                if conferences == nil then 
                  cgilua.print('<p>NULO</p>') 
                else
                  i = 0
                  for k,v in pairs(conferences) do                   
                    if string.match(v, "name_conference") then
                      i = i + 1
                      v = string.gsub (v, '"name_conference" : "', '', 1)
                      v = string.gsub (v, '",', '', 1)
                      cgilua.print('<a href='..cfg.file_conference_home..
                                    '?conference='..confs[i]..'>'..v
                                    ..'</a>&nbsp;&nbsp;\n')
                    end
                  end                  
                end
              %>
              <br/>
              <br><a href="<%=cfg["file_paper_cited"]%>?limit=<%=limit%>">
                   Mais citados | Más Citados | Most Cited</a>
            </font></b>
         </p>
      </td>
      </tr>
   </table>
   	<table align="center" width="50%">
		<% dofile"google_search_box.lua" %>
	<table>
</body>

<footer>
  <hr width="80%" align=center>
  <table width="80%" align=center>
    <tr>
		
	
      <td width="40%" align=right>
        <a target="_blank" href="<%=cfg["file_wtrans_home"]%>">
			    <img border="0" src="<%="logo_wtrans_new.jpg"%>"width="350" height="56">
	</a>
      </td>
	  
	  <td width="5%" align=right>
        
      </td>
	   
	 <td width="12%" align=left><!-- Start BDBCOMP -->
        <a href="http://www.lbd.dcc.ufmg.br/bdbcomp/servlet/PesquisaEvento?evento=wtrans" target="_blank">BDBComp</a>
      </td>
      <!-- End BDBCOMP -->
		
      <td align=right><!-- Start StatCounter -->
        <script type="text/javascript" language="javascript">
			  var sc_project=9288094; 
			  var sc_invisible=0; 
			  var sc_partition=23; 
			  var sc_security="c7f358fe"; 
			  var sc_text=3; 
			</script>
			<script type="text/javascript" language="javascript" src="http://www.statcounter.com/counter/counter.js"></script><br>
			<a href="http://my.statcounter.com/project/standard/stats.php?project_id=9288094&amp;guest=1">StatCounter</a>
		  </p>
      </td><!-- End of StatCounter Code -->
    </tr>
  </table>
</footer>
</html>
