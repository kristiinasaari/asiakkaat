<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel = "stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaiden haku</title>
</head>

<body>
<table id="listaus" border="1"> <%-- SIIVOA BORDER POIS LOPUKSI --%>
		<thead>
			<tr>
				<th colspan="5" class="oikealle"><span id="uusiAsiakas">Lisää uusi asiakas</span></th>
			</tr>
			<tr>
				<th class="oikealle">Hakusana:</th>
				<th colspan="3"><input type="text" id="hakusana"></th>
				<th><input type="button" value="Hae" id="hakunappi"></th>
			</tr>
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
		</tbody>
</table>
<script>
$(document).ready(function(){
	
	$("#uusiAsiakas").click(function(){
		document.location="lisaaasiakas.jsp";
	});
	
	haeAsiakkaat();
	$("#hakunappi").click(function(){		
		haeAsiakkaat();
	});
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteriä painettu, ajetaan haku
			  haeAsiakkaat();
		  }
	});
	$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
});

function haeAsiakkaat(){
	$("#listaus tbody").empty();
	$.ajax({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){
		$.each(result.asiakkaat, function(i, field){
			var htmlStr;
			htmlStr+="<tr id='rivi_"+field.etunimi+"'>";
			htmlStr+="<td>"+field.etunimi+"</td>";
			htmlStr+="<td>"+field.sukunimi+"</td>";
			htmlStr+="<td>"+field.puhelin+"</td>";
			htmlStr+="<td>"+field.sposti+"</td>";
			htmlStr+="<td><span class='poista' onclick=poista('"+field.etunimi+"')>Poista</span></td>";
			htmlStr+="</tr>";
			$("#listaus tbody").append(htmlStr);
		});	
	}});
}
function poista(etunimi){
	if(confirm("Poista asiakas " + etunimi +"?")){
		$.ajax({url:"asiakkaat/"+etunimi, type:"DELETE", dataType:"json", success:function(result) { //joko {"response:1"} tai {"response:0"}
	        if(result.response==0){
	        	$("#ilmo").html("Asiakkaan poisto epäonnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+etunimi).css("background-color", "red"); //Värjätään poistetun asiakkaan rivi
	        	alert("Asiakkaan " + etunimi +" poisto onnistui.");
				haeAsiakkaat();        	
			}
	    }});
	}
}

</script>
</body>
</html>