<%
  dofile"dao.lua"
  local cfg = dofile"config.lua"
  local n = tonumber(cgilua.QUERY.limit) or 20
%>
<html>
<head>
  <title>Mais citados | Más Citados | Most Cited</title>
  
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

	<!-- google chart-->
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>

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
  <h2 align=center>Mais citados | Más Citados | Most Cited</h2>
<%
	--get most cited papers (20)
    local  most_cited = dao.get_papers_most_cited()
    -- PRINT TEXT FOR PAPERS, DOWNLOADS, CITATIONS AND DIV FOR CHART
	local papers = ''
	local downloads = ''
	local citations = ''
	local labels = ''
	local i = 1
	for k, v in pairs(most_cited) do
		local x = dao.split_string(v, "<br/>")
		local p = dao.separate_in_key_value(x)
		if papers == '' then
			papers = i
		else
			papers = papers .. ',' .. i
		end
		
		if downloads == '' then
			downloads = p["num_downloads"]
		else
			downloads = downloads .. ',' .. p["num_downloads"]
		end
		
		if citations == '' then
			citations = p["num_citations"]
		else
			citations = citations .. ',' .. p["num_citations"]
		end
		if labels == '' then
			labels = p["file_name"]
		else
			labels = labels .. ',' .. p["file_name"]
		end
		i = i + 1
	end

	cgilua.print("<input type= 'hidden' id ='papers' value = '"..papers.."'>")
	cgilua.print("<input type= 'hidden' id ='labels' value = '"..labels.."'>")
	cgilua.print("<input type= 'hidden' id ='downloads' value = '"..downloads.."'>")
	cgilua.print("<input type= 'hidden' id ='citations' value = '"..citations.."'>")
	cgilua.print("<div id='chart_div'></div>")
	
	--print tables of sessions of papers	
	--ATUALIZAR O NUMERO DE CITACOES DO PAPER (20 ULTIMOS ATUALIZADOS) 1 VEZ X DIA
	--local update_most_cited = dofile(cfg.file_most_cited)

	local most_cited = dao.get_papers_most_cited()
	local i = 0
	if most_cited ~= nil then
		-- Open new table if it changed
		cgilua.print('<table cellspacing=\"1\" class=\"tablesorter\">')
		cgilua.print('<thead>')
			cgilua.print('<tr>')
				cgilua.print('<th>Paper&nbsp</th>')
				cgilua.print('<th>Edição&nbsp</th>')
				cgilua.print('<th>Citações&nbsp&nbsp</th>')
				cgilua.print('<th>Downloads&nbsp</th>')
			cgilua.print('</tr>')
		cgilua.print('</thead>')
		cgilua.print('<tbody>')
		for k, v in pairs(most_cited) do
			local x = dao.split_string(v, "<br/>")
			local p = dao.separate_in_key_value(x)
			i = i + 1
			  --number of downloads
			  
			  local downloads = 0
				downloads = p["num_downloads"]
			  local  citations = 0
				citations = p["num_citations"]
				--end	
			  local scholar_url = require"scholar/scholar_string_cleaner".montaUrl(
										  cfg.scholar_base_url, p["paper_title"], p["author"])
			  
			 			  -- print each paper published IN A SORTED TABLE
		      cgilua.print('<tr>')
		      	    cgilua.print('<td>')
		      			cgilua.print(string.format(
		      			"<div><h2><b>%s</b>.</h2></div>", p["paper_title"] or ""
		      			))
		      			cgilua.print(string.format(
		      			-- "<font size='2'>%s,".." %s. "..anais_string..", pp %s</font><br>", p["author"], p["add_author"], p["page"] or ""
		      			"<font size='2'>%s"..", %s</font><br>", p["author"], p["add_author"] or ""
		      			))
		      			cgilua.print('[')
		      			cgilua.print(string.format(
		      			"<a href='artigos/artigos_%s/%s' target='_blank' onClick=\"ga('send', 'event', { eventCategory: 'Papers', eventAction: 'Download', eventLabel: '%s'} );\" >pdf</a>", p["name_conference"], p["file_name"], p["file_name"] or ""
		      			))
		      			cgilua.print('] - ')
		      			cgilua.print('[')
		      			cgilua.print(string.format(
		      			"<a href='%s' target='_blank'>scholar</a>", scholar_url or ""
		      			))
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
						cgilua.print(string.format("<font face='Arial' size='2' data-analytics-label='%s' class='downloads-number' old-downloads-number='%s'>", p["file_name"], p["num_downloads"]))
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
			Infelizmente, ainda não existem citações para artigos dessa conferência.
			<br>
			Unfortunately, there are still no citations for articles of this conference.
			<br>
			Desafortunadamente, todavía no hay citas de artículos de esta conferencia.
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

		// Draw google chart
		function initGoogleCharts(downloadsJson) {
			var drawer = new PapersChartDrawer(downloadsJson);
			google.load('visualization', '1', {packages: ['corechart', 'bar']});
			google.setOnLoadCallback(drawer.drawAnnotations);
		}

		function PapersChartDrawer(downloadsJson) {
			var OPTIONS = {
				title: 'Downloads e Citações',
				annotations: {
					alwaysOutside: true,
					textStyle: {
					fontSize: 14,
					color: '#000',
					auraColor: 'none'
					}
				},
				hAxis: {
					title: 'Papers',
					format: '',
					viewWindow: {
					min: [7, 30, 0],
					max: [17, 30, 0]
					}
				},
				vAxis: {
					title: 'Ocorrências'
				}
			};

			this.drawAnnotations = function() {
				//pegar papers downloads e citations do HTML
				var array_papers = (document.getElementById('papers').value).split(",");
				var array_labels = (document.getElementById('labels').value).split(",");
				var array_citations = (document.getElementById('citations').value).split(",");
				var array_old_downloads = (document.getElementById('downloads').value).split(",");
				var array_downloads = array_downloads_from_json(array_labels, downloadsJson);
				var array_total_downloads = sumArray(array_downloads, array_old_downloads);
				var data = buildDataTableWith(array_papers, array_total_downloads, array_citations);
				var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
				chart.draw(data, OPTIONS);
			};

			function buildDataTableWith(array_papers, array_downloads, array_citations) {
					var data = new google.visualization.DataTable();
					data.addColumn('string', 'xAxisNames');
					data.addColumn('number', 'Downloads');
					data.addColumn('number', 'Cita��es');
					//criar data json para o gerador de grafico
					var jsonNodes = [];
					for	(index = 0; index < array_papers.length; index++) {
						var paperNumber = index+1;
						var itemNode = []
						itemNode.push({v: "", f: array_papers[index]});
						itemNode.push(parseInt(array_downloads[index]));
						itemNode.push(parseInt(array_citations[index]));
						jsonNodes.push(itemNode);
					}
					data.addRows(jsonNodes);
					return data;
			}

			function array_downloads_from_json(labels, downloadsJson) {
				var downloads = [];
				for(var labeli in labels) {
					var label = labels[labeli];
					downloads.push(downloadsJson[label] || 0);
				}
				return downloads;
			}

			function sumArray(a, b) {
			    var c = [];
			    for (var i = 0; i < Math.max(a.length, b.length); i++) {
			        c.push((parseInt(a[i]) || 0) + (parseInt(b[i]) || 0));
			    }
			    return c;
			}
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
