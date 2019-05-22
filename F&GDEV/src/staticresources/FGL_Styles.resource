.selected{
	background-color: #ECBE13;
}

.bg-approved{
	background: url('/resource/1412001594000/fgl_icons/approved.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-filed{
	background: url('/resource/1412001594000/fgl_icons/filed.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-inprogress{
	background: url('/resource/1412001594000/fgl_icons/inprogress.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-notstarted{
	background: url('/resource/1412001594000/fgl_icons/notstarted.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-nbs{
	background: url('/resource/1412001594000/fgl_icons/nbs.png') no-repeat;
	background-position: center;
}
.bg-notfiling{
	background: url('/resource/1412001594000/fgl_icons/notfiling.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-closed{
	background: url('/resource/1412001594000/fgl_icons/closed.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-targeted{
	background: url('/resource/1412001594000/fgl_icons/targeted.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-pendingactsupport{
	background: url('/resource/1412001594000/fgl_icons/pendingactsupport.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-withdrown{
	bbackground: url('/resource/1412001594000/fgl_icons/withdrawn.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.bg-objection{
	background: url('/resource/1412001594000/fgl_icons/objection.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.pointer{cursor: pointer}
/*
.glyphicon-ok:before {
	content: "" !important;
}
.glyphicon-ban-circle:before {
	content: ""!important;
}*/
.glyphicon-fgl-ban-circle {
	background: url('/resource/1412001594000/fgl_icons/circlex.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.glyphicon-fgl-ok {
	background: url('/resource/1412001594000/fgl_icons/check.png') no-repeat;
	background-position: center;
	background-size: 20px 20px;
}
.statescolumn {
	position: absolute;
	top: 326px;
}
.stateTable {
	float: left;
	border-right: 5px solid #999;
	width: 800px;
	position: relative;
	left: 158px;
	top: -2px;
	overflow-x: scroll;
}
@media screen and (-webkit-min-device-pixel-ratio:0) {
.stateTable { top: 0;  }
}
.stateTable table {
	border: 0 !important;
	width: 100%;
	overflow-x: scroll;
}
.stateTable td {
	/*padding: 15px !important;*/
}
.productTable {
	float: left;
	width: 800px;
	position: absolute;
	left: 981px;
	top: 302px;
	overflow-x: scroll;
	border-right: 5px solid #999;
}
/*.productTable .table-condensed>thead>tr>th.buttonTH {
	padding: 9px 0 5px 5px !important;
}*/
.productTable table {
	overflow-x: scroll;
}
.productTable table td {
	padding: 15px !important;
}
.productTable thead tr {
	padding: 0 !important;
}
.headerTable td, .table-bordered>thead>tr>th {
	vertical-align: bottom;
}
.stateTable .btn {
	white-space: nowrap;
}
.headerTable, .headerTable table {
width: 100%;
border-bottom: 2px solid #999;
border-top: none;
border-left: none;
border-right: none;
margin-bottom: 0 !important;
position: relative;
left: 79px;
}

th.statesBlock {
	width: 153px;
	border: 1px solid white !important;
	background-color: #DDDDDD;
}
td.stateName {
	width: 158px;
}
.statesPolicyNameBlock {
	width: 150px;
	border: 1px solid white !important;
	background-color: #DDDDDD;
}
.productPolicyNameBlock {
	width: 100px;
	border: 1px solid white !important;
	background-color: #DDDDDD;
}
table.buttonTable.ng-scope {
	width: 1255px;
	margin-bottom: 10px;
}
.buttonTable th {
	/*width: 56%;*/
}
.buttonTable .btn {
	float: left;
	margin-right: 15px !important;
	background-color: #ECBE13 !important;
	border: none !important;
	background-image: none !important;
	border-radius: 0 !important;
	padding: 8px 15px !important;
	color: #75725B !important;
}
th.buttonCell {
	white-space: normal !important;
	padding: 0 !important;
	vertical-align: bottom !important;
	width: 680px;
}
.policyStatusBlock {
	width: 153px;
	text-align: center;
}
.productBlock {
	background-color: #666;
	border: 1px solid white !important;
	color: white;
	padding: 2px 0 2px 5px !important;
}
.policyBlock.empty {
	padding: 2px 0 !important;
}
.wrapper {

}
/*  SINGLE GRID STYLES  */

.thirdWheel .statescolumn {
	top: 210px;
}
.thirdWheel .stateTable {
	border-right: 1px solid #ddd;
	overflow: visible;
}
.alert-null {
	background-color: white;
	border: none;
}
.alertTable p {
    color: #777;
    font-style: italic;
}
.alertTable span {
    text-transform: uppercase;
}


/*  SFDC STYLE OVERWRITES 
Getting rid of standard SF background colors, borders, etc.
*/
body .bPageBlock, body #bodyCell .bResource .secondaryPalette, body .secondaryPalette.bPageBlock, body .individualPalette .secondaryPalette.bPageBlock, body .bodyDiv .genericTable, body .genericPageBlockTable, body .bodyDiv .bSubBlock, body .bComponentBlock .bPageBlock, body .bMyDashboard .bPageBlock, body.rlHoverFrame .bPageBlock, body.subjectSelectionPopup div.choicesBox, body.lookupTab .secondaryPalette.bPageBlock, body.popupTab .secondaryPalette.bPageBlock, body.UserTagStatsPage .secondaryPalette.bPageBlock {
	background-color: white;
	border: none;
}
body .bPageBlock .pbHeader {
background-color: white;
}
.bEditBlock .pbHeader>table, .apexp .bPageBlock.apexDefaultPageBlock .pbHeader>table, #ep.bLayoutBlock .pbHeader>table {
border-bottom: none;
}
.homeTab .listViewport .subNav .linkBar, .homeTab .mComponent .cHeader, .homeTab .genericTable, .homeTab .bSubBlock, .homeTab .bPageBlock {
border-top: none;
}
body .bPageBlock, body .bPageBlock .pbBody, body .bPageBlock .pbBottomButtons {
background-color: white !important;
}

.zen, div#AppBodyHeader, .bodyDiv {
min-width: 1800px;
}
#sidebarCell {
display: none;
}
/*  ANGULAR STYLE OVERWRITES 
Overwriting AngularJS styles
*/
hr {
margin: 0;
border: none;
}
/* BOOTSTRAP STYLE OVERWRITES
Overwriting Bootstrap styles
*/
.table-bordered>thead>tr>th, .table-bordered>thead>tr>td {
border: none !important;
}
.table-bordered {
	border: none !important;
}
ul.pager.ng-isolate-scope.ng-pristine.ng-untouched.ng-valid, ul.pager.ng-isolate-scope.ng-untouched.ng-valid.ng-dirty {
	margin: 0;
	padding: 0;
}
.pager li>a, .pager li>span {
padding: 1px 10px;
background-color: #ECBE13;
border: none;
border-radius: 2px;
}
.pager .disabled>a, .pager .disabled>a:hover, .pager .disabled>a:focus, .pager .disabled>span {
color: #999;
background-color: #ccc;
cursor: not-allowed;
}
button.btn.btn-warning:hover, button.btn.btn-primary:hover {
color: black !important;
border: 1px solid orange;
}
.alert {
	height: 52px !important;
}
