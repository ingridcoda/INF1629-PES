<%
  dofile"dao.lua"
  local cfg = dofile"config.lua"
  local n = tonumber(cgilua.QUERY.limit) or 20
  
%>
<html>
<head>
	<title>Todos os Papers | Todos los Papers | All Papers</title>
	<!--
	jQuery plugin: Tablesorter 2.0 - Sort table using a link outside the table
	-->
	<link rel="stylesheet" href="../themes/blue/style.css" type="text/css" id="" media="print, projection, screen" />
	<script type="text/javascript" src="../js/jquery-latest.js"></script>
	<script type="text/javascript" src="../js/jquery.tablesorter.js"></script>

	<script type="text/javascript" id="js">
	$(document).ready(function() {
		$("table").tablesorter();
		$("#trigger-link").click(function() {
			// set sorting column and direction, this will sort on the first and third column the column index starts at zero
			var sorting = [[0,0],[2,0]];
			// sort on the first column
			$("table").trigger("sorton",[sorting]);
			// return false to stop default link action
			return false;
		});
	});
	</script>

	<!-- google api -->
	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

	  ga('create', 'UA-69457653-1', 'auto');
	  ga('send', 'pageview');

	</script>
	<!-- end google api -->
</head>
<body>
  <h2 align=center>Todos os Papers | Todos los Papers | All Papers</h2>
<%
	--print tables of sessions of papers	
	local all_papers = dao.get_all_papers()
	local i = 0
	if all_papers ~= nil then
		-- Open new table if it changed
		cgilua.print('<table cellspacing=\"1\" class=\"tablesorter\">')
		cgilua.print('<thead>')
		cgilua.print('<tr>')
		cgilua.print('<th>Paper&nbsp</th>')
		cgilua.print('<th>Edição&nbsp</th>')
		cgilua.print('<th>Citações&nbsp</th>')
		cgilua.print('<th>Downloads&nbsp&nbsp</th>')
		cgilua.print('</tr>')
		cgilua.print('</thead>')
		cgilua.print('<tbody>')
		for k, v in pairs(all_papers) do
			local x = dao.split_string(v, "<br/>")
			local p = dao.separate_in_key_value(x)
			i = i + 1
			--number of downloads
			local downloads = 0
			downloads = p["num_downloads"]
			local  citations = 0
			citations = p["num_citations"]
			local scholar_url = require"scholar/scholar_string_cleaner".montaUrl(cfg.scholar_base_url, p["paper_title"], p["author"])
			-- print each paper published IN A SORTED TABLE
			cgilua.print('<tr>')
			cgilua.print('<td>')
			cgilua.print(string.format("<div><h2><b>%s</b>.</h2></div>", p["paper_title"] or ""))
			cgilua.print(string.format(-- "<font size='2'>%s,".." %s. "..anais_string..", pp %s</font><br>", p["author"], p["add_author"], p["page"] or ""
								"<font size='2'>%s"..", %s</font><br>", p["author"], p["add_author"] or ""))
			cgilua.print('[')
			cgilua.print(string.format("<a href='artigos/artigos_%s/%s' target='_blank' onClick=\"ga('send', 'event', { eventCategory: 'Papers', eventAction: 'Download', eventLabel: '%s'} );\" >pdf</a>", p["name_conference"], p["file_name"], p["file_name"] or ""))
			cgilua.print('] - ')
			cgilua.print('[')
			cgilua.print(string.format("<a href='%s' target='_blank'>scholar</a>", scholar_url or ""))
			cgilua.print(']')
			cgilua.print(string.format("<br><br>"))
			
			cgilua.print('</td>')	
			cgilua.print('<td>')
			cgilua.print(string.format("<font face='Arial' size='2'> %s </font>", p["name_conference"] or ""))
			cgilua.print('</td>')
			cgilua.print('<td>')
			cgilua.print(string.format("<font face='Arial' size='2'>Citado por: %s </font>", citations))
			cgilua.print('</td>')
			cgilua.print('<td>')
			cgilua.print(string.format("<font face='Arial' size='2' data-analytics-label='%s' class='downloads-number' old-downloads-number='%s'>", p["file_name"], downloads))
			cgilua.print("Downloads: ...")
			cgilua.print("</font>")
			cgilua.print('</td>')
			cgilua.print('</tr>')
		end
		--LAST TABLE
		-- Close old table if it changed
		cgilua.print('</tbody></table>')
	end
	if i == 0 then
		cgilua.print([[
		  <center>
			<br>
			Infelizmente, ainda não existem artigos dessa conferência.
			<br>
			Unfortunately, there are still no papers of this conference.
			<br>
			Desafortunadamente, todavía no hay artículos de esta conferencia.
			<br>
		  </center>
		  <br>
			]])
	end
%>
<a href="<%=cfg["file_paper_home"]%>">voltar</a>
</body>
<script type="text/javascript">
		function putDownloadsNumbersOnTable(downloadsJson) {
			$(".downloads-number").each(function(){
				var label = $(this).attr("data-analytics-label");
				var oldDownloadsNumber = $(this).attr("old-downloads-number");
				var downloadsNumber = downloadsJson[label] || 0;
				var sumDownload = parseInt(downloadsNumber)+parseInt(oldDownloadsNumber);
				$(this).text("Downloads: " + sumDownload );
			});
		}
</script>
	<!-- ###  Main script ### -->
 <script type="text/javascript">
		(function() {
			var response = $.ajax({
				url: "http://wtrans-analytics.herokuapp.com/downloads.json",
				method: "get",
				async: false
			});

			var json = JSON.parse(response.responseText);
			

			$(function() {
				putDownloadsNumbersOnTable(json);
				$("table").tablesorter(); // Setup sorting on the tables
			});
		}());
	</script>
<footer>
  <% dofile"footer.lua" %>
</footer>
</html>
