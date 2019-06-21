<html>
<head>
  <title>Cadastra confer�ncias no BD do WTranS</title>
</head>

<body>
  <%
    local campo = dofile("campo.lua")
    local cfg = dofile("../config.lua")
  %>
  <p style="margin-left: 50; margin-right: 50">
  <img border="0" src="<%="logo_wtrans_papers.jpg"%>"
   width="100" height="62"><font face="Arial" size="4">(Workshop em Engenharia
   de Requisitos)</font></p>
      
  <p style="margin-left: 50; margin-right: 50">
  <font face="Arial">Preencha o formul�rio para inserir os dados no BD de 
  artigos do WTranS.<br>
  Os campos com (*) s�o obrigat�rios.<br>
  Se n�o forem preenchidos adequadamente haver� problemas no BD.</font></p>
      
  <p style="margin-left: 50; margin-right: 50">
  <b><font size="5" face="Arial">Dados da Confer�ncia</font></b></p>
      
  <div style="width: 736; border-style: solid; border-width: 1; padding-left: 4; padding-right: 4; padding-top: 1; padding-bottom: 1">
      
  <form method="POST" action="add_conference.lp">
    <table border="0" cellpadding="0" cellspacing="0" 
           style="border-collapse: collapse" bordercolor="#111111" width="100%">

      <%= campo("Nome da Confer�ncia*", "name", cgilua.QUERY.name or 'WTRANS',
                "Ex: WTranS13") %>
      <%= campo("URL*", "url", cgilua.QUERY.url,
                "Ex: WTranS.inf.puc-rio.br/WTranS13") %>
      <%= campo("Editores*", "editor", cgilua.QUERY.editor,
                "separados por virgula") %>
      <%= campo("ISBN*", "isbn", cgilua.QUERY.isbn) %>
      <%= campo("M�s", "month", cgilua.QUERY.month, "em portugu�s") %>
      <%= campo("Dias", "days", cgilua.QUERY.days, "Ex: 13-14") %>
      <%= campo("Ano", "year", cgilua.QUERY.year, "Ex: 2005") %>
      <%= campo("Cidade", "city", cgilua.QUERY.city,
                "Ex: Piracicaba-SP") %>
      <%= campo("Pa�s", "country", cgilua.QUERY.country) %>

    </table>
    <p style="margin-left: 50; margin-right: 50">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="submit" value="Submit" name="B1"><input type="reset" value="Reset" name="B2"></p>
  </form>
  </div>
</body>
</html>
