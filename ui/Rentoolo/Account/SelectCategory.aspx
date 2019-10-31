<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SelectCategory.aspx.cs" Inherits="Rentoolo.Account.SelectCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        
.categories {
	text-align: center;
}
.categories h2 {
	font-weight: 300;
}
.btn-two {
	margin: 9px;
    text-decoration: none;
    font-size: 22px;
    font-weight: bold;
}
.btn-two:hover {
	text-decoration: none;
}

.btn.block, 
.btn-two.block, 
.btn-gradient.block, 
.btn-effect.block {
  display: block;
  width: 80%;
  margin-left: auto;
  margin-right: auto;
  text-align: center;
}
.btn-gradient.large {
  padding: 15px 45px; 
  font-size: 26px;
}

.btn-two.cyan     {background-color: #71ceeb;}

/* Button two - I have no creativity for names */
.btn-two {
	color: white;	
	padding: 10px 15px;
	display: inline-block;
	border: 1px solid rgba(0,0,0,0.21);
	border-bottom-color: rgba(0,0,0,0.34);
	text-shadow:0 1px 0 rgba(0,0,0,0.15);
	box-shadow: 0 1px 0 rgba(255,255,255,0.34) inset, 
				      0 2px 0 -1px rgba(0,0,0,0.13), 
				      0 3px 0 -1px rgba(0,0,0,0.08), 
				      0 3px 13px -1px rgba(0,0,0,0.21);
}
.btn-two:active {
	top: 1px;
	border-color: rgba(0,0,0,0.34) rgba(0,0,0,0.21) rgba(0,0,0,0.21);
	box-shadow: 0 1px 0 rgba(255,255,255,0.89),0 1px rgba(0,0,0,0.05) inset;
	position: relative;
}

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="categories">
        <h2>Категории:</h2>
        <a href="#" class="btn-two cyan block">Транспорт</a>
        <a href="#" class="btn-two cyan block">Недвижимость</a>
        <a href="#" class="btn-two cyan block">Работа</a>
        <a href="#" class="btn-two cyan block">Услуги</a>
        <a href="#" class="btn-two cyan block">Для дома и дачи</a>
        <a href="#" class="btn-two cyan block">Для бизнеса</a>
        <a href="#" class="btn-two cyan block">Бытовая электроника</a>
        <a href="#" class="btn-two cyan block">Хобби и отдых</a>
        <a href="#" class="btn-two cyan block">Животные</a>
    </div>
</asp:Content>
