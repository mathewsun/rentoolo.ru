<%@ Page Title="Обмен" Language="C#" MasterPageFile="~/SiteBalance.Master" AutoEventWireup="true" CodeBehind="Exchange.aspx.cs" Inherits="Rentoolo.Account.Exchange" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">



    
    <script type="text/javascript">
        jQuery(document).ready(function ($) {
            var topMenu = $("#top-navigation"),
            menuItems = topMenu.find("a");
            menuItems.parent().removeClass("active");
            menuItems.filter("[id*='ExchangeLink']").parent().addClass("active");
        });
    </script>
</asp:Content>
