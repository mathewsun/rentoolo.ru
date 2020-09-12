<%@ Page Title="Тендеры" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tender.aspx.cs" Inherits="Rentoolo.Account.Tender" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>some</h1>
    <div class="media-body-inline-grid"
        
    <% foreach (var tender in tenders) { %>
        <a href="TenderInfo.aspx?id=<%=tender.Id %>">
            Name:<%= tender.Name %> <br />
        </a>
    <% } %>

</asp:Content>
