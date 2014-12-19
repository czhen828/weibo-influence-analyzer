<%@page import="weibo4j.model.Status"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <link href="default.css" rel="stylesheet"> 
 
    <link href="bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="bootstrap-responsive.css" rel="stylesheet">
    <link href="bootstrap.css" rel="stylesheet">

    <style type="text/css">
	body {
		padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
	}
	
	/* Custom container */
	.container-narrow {
		margin: 0 auto;
		max-width: 900px;
		border-style: solid;
		border-color: transparent;
		background-color: #D8D8D8	;
		z-index: 9;
		height : 100%;
		-moz-border-radius: 15px;
		border-radius: 15px;
	}
	
	.container-narrow > hr {
		margin: 30px 0;
	}
	
	.sidebar-nav {
		padding: 20px 0;
	}
	
	@media (max-width: 980px) {
		/* Enable use of floated navbar text */
		.navbar-text.pull-right {
			float: none;
			padding-left: 5px;
			padding-right: 5px;
		}
	}	 
	</style>  
<%
	String BAIDU_MAP_AK = (String)request.getAttribute("BAIDU_MAP_AK");
	if(BAIDU_MAP_AK!=null){
		%>
		<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=<%=BAIDU_MAP_AK %>"></script>
		<%
	}
%>
    <script src="jquery-1.11.2.min.js"></script>
    <script>
var mapOptions;
var geocoder;
var map;
function initialize() {
	if(!BMap){
		// 没有设置百度地图的AK，所以百度地图没有加载。
		// 请在System.env中设置BAIDU_MAP_AK = 百度地图AK
		return;
	}
	
  var address = '中国';
  
	//百度地图API功能
	var map = new BMap.Map("map-canvas");
  
  geocoder = new BMap.Geocoder();
  // 添加带有定位的导航控件
  var navigationControl = new BMap.NavigationControl({
    // 靠左上角位置
    anchor: BMAP_ANCHOR_TOP_LEFT,
    // LARGE类型
    type: BMAP_NAVIGATION_CONTROL_LARGE,
    // 启用显示定位
    enableGeolocation: true
  });
  map.addControl(navigationControl);
  // 添加定位控件
  var geolocationControl = new BMap.GeolocationControl();
  geolocationControl.addEventListener("locationSuccess", function(e){
    // 定位成功事件
    var address = '';
    address += e.addressComponent.province;
    address += e.addressComponent.city;
    address += e.addressComponent.district;
    address += e.addressComponent.street;
    address += e.addressComponent.streetNumber;
    console.log("当前定位地址为：" + address);
  });
  geolocationControl.addEventListener("locationError",function(e){
    // 定位失败事件
    console.log(e.message);
  });
  map.addControl(geolocationControl);
  
  geocoder.getPoint(address, function(point) {
		if (point) {
			map.centerAndZoom(point,5);
		}
		
		<%	
			List<Status> result1 = (List<Status>) request.getAttribute("result1");
			for(Status status : result1 ) {
				String text = status.getText().replace("\"", "'").replace("\n", " ").replace("\'", "");
				text = " "+text+" ";
				String location = status.getUser().getLocation();
				String screenName = status.getUser().getScreenName();
				String prof_img = status.getUser().getProfileImageURL().toString();
			
		%>
		
		var loc1 = "<%= location %>";
		geocoder.getPoint(loc1, function (point) {
		// console.debug("Check here: ", new_result)
		var loc = "<%= location %>";
		var txt = '<%= text %>';
		var scrName = '<%= screenName %>';
		var profile_img = '<%= prof_img %>';
		
		var contentString = '<div id="content">'+
		      '<div id="siteNotice">'+
		      '</div>'+
		      '<h3 id="firstHeading" class="firstHeading"><img id="profile_img" src='+profile_img+' class="img-rounded">'+ scrName+'</h3>'+
		      '<div id="bodyContent">'+
		      txt  + 
		      '</div>'+
		      '</div>';

		var infowindow = new BMap.InfoWindow(contentString);  // 创建信息窗口对象

		var marker = new BMap.Marker(point);
		map.addOverlay(marker);
		marker.addEventListener("click", function(){          
			   this.openInfoWindow(infoWindow);
			   //图片加载完毕重绘infowindow
			   document.getElementById('profile_img').onload = function (){
				   infoWindow.redraw();   //防止在网速较慢，图片未加载时，生成的信息框高度比图片的总高度小，导致图片部分被隐藏
			   }
			});
		
		});
		<%
			}
		%>	
  });
}


    </script>
  </head>

  <body>
  
  <script src="/bootstrap.min.js"></script>
  <script src="/bootstrap.js"></script>
  <script src="/bootstrap-tooltip.js"></script>

  <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          
          <a class="brand pull-left" href="../"><em>微博影响力分析器 </em><small>v1.2</small></a>
	  
          <div class="nav-collapse collapse">
			<a href="./" type="button" class="btn btn-primary">« 再分析一次...</a>
          </div>  <!--  /.nav-collapse  -->
        </div>
      </div>
  </div>  <!-- end of div for nav bar-->


<div class="container-fluid">
  <div class="row-fluid">

<div class="span4">
  <h1>影响力分析结果: <%= request.getAttribute("totalscore") %>/200</h1>
  <table class="table table-condensed">
  <tr>
  <td>微博名:</td>
  <td><%= request.getAttribute("t_name") %></td>
  </tr>
  <tr>
  <td>Klout 分数: </td>
  <td><%= (String) request.getAttribute("score") %></td>
  </tr>
  <tr>
  <td>粉丝数:</td>
  <td><%= request.getAttribute("fcount") %></td>
  </tr>
  <tr>
  <td>粉丝分数:</td>
  <td><%= request.getAttribute("fscore") %></td>
  </tr>
  <tr>
  <td>转发数:</td>
  <td><%= request.getAttribute("rtcount") %></td>
  </tr>
  <tr>
  <td>转发分数:</td>
  <td><%= request.getAttribute("rtscore") %></td>
  </tr>
  <tr>
  <td>最近埃塔我:</td>
  <td><%= request.getAttribute("mcount") %> / 100</td>
  </tr>
  </table>
  <br>
  <form action="SaveData" method="post">
  <input type="hidden" name="totalscore" value="<%= request.getAttribute("totalscore") %>">
  <input type="hidden" name="t_name" value="<%= request.getAttribute("t_name") %>">
  <input type="hidden" name="fcount" value="<%= request.getAttribute("fcount") %>">
  <input type="hidden" name="fscore" value="<%= request.getAttribute("fscore") %>">
  <input type="hidden" name="rtcount" value="<%= request.getAttribute("rtcount") %>">
  <input type="hidden" name="rtscore" value="<%= request.getAttribute("rtscore") %>">
  <input type="hidden" name="mcount" value="<%= request.getAttribute("mcount") %>">
  <input type="submit" value="Save User to Database" class="btn btn-success">
  <a class="btn btn-primary" href="DisplayAll">查看数据库</a>
  </form>
</div>

<div class="span8">
  <div class="row-fluid">
  <div>
  <h3>最新10条微博:</h3>
  	<table class="table table-condensed"> 
  	<tr>
  		<td>内容</td>
  		<td>转发数</td>
  	</tr>
		<%
		java.util.List<Status> rtweets  = (java.util.List<Status>) request.getAttribute("rtweets");
		int count = 0 ;
		for ( Status tweet : rtweets) {
			if (count >=10) break;
			int retweetCount = (int)tweet.getRepostsCount();
			String tweetText = tweet.getText();
			count ++;
		%>
		<tr>
			<td><%= tweetText %></td>
			<td><%= retweetCount%></td>
		</tr>
		<%	
		}
		%>
  	</table>
  </div> <!-- end of the span6 for table-->
  </div> <!-- end of row-fluid for span6 -->


<div class="row-fluid">
  <div>
  <h3>最新发表在: </h3>
  <div id="map-canvas"></div> 
  </div> <!-- end of span6 for map-canvas-->
</div> <!-- end of row fluid for span6-->
 
</div> <!-- end of the span8 div -->


</div>  <!-- end the div row-fluid -->
</div>  <!-- ends the div container-fluid --> 

</body>
  </html>