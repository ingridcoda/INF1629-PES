<%
  local cfg = dofile"config.lua"
  local limit = cfg.file_most_cited_limit
%>
<html>
<head>
   <title>WTranSartigos - Artigos Publicados no Workshop de Transpar�ncia em Sistemas</title>
</head>

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
              Art�culos publicados en WTranS</br>Papers published on WTranS
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
              sum�rio dos anais (para cada edi��o) ou por busca livre
              utilizando-se a m�quina de busca Google (para todas as edi��es).
              A busca Google � livre e acessa os artigos em pdf.
            </font>
            </br></br>
            <font face="Arial" color="gray">WTranSArtigos pone a su disposici�n
              los art�culos publicados en los anales de todos los Workshops
              <%cgilua.print('<a href="'..cfg.file_wtrans_home..'" target='..
              '"_blank">WTranS</a>')%>. Es posible acceder a los mismos utilizando
              el resumen de los anales (para cada edici�n) o mediante el motor
              de b�squeda Google (para todas las ediciones). La b�squeda en
              Google permited acceder a los art�culos en formato pdf.
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
                -- list all wtrans conferences using dao to access the database
                dofile"dao.lua"
                conferences = dao.get_conferences_json()
                for v in conferences do
                  cgilua.print('<a href='..cfg.file_conference_home..
                  '?conference='..v.name_conference..'>'..v.name_conference
                  ..'</a>&nbsp;&nbsp;\n')
                end
              %>
              <br><a href="<%=cfg["file_paper_cited"]%>?limit=<%=limit%>">
                   Mais citados | M�s Citados | Most Cited</a>
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
      <td width="34%" align=right>
        <a target="_blank" href="<%=cfg["file_wtrans_home"]%>">
	  <img border="0" src="<%="logo_wtrans_new.jpg"%>"
               width="150" height="56">
	</a>
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
