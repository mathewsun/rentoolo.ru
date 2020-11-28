<%@ Page Title="News Antares" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewsAntares.aspx.cs" Inherits="Rentoolo.NewsAntares.NewsAntares" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1><%: Title %></h1>
    </hgroup>
    <br />
    <% foreach (var item in ListNews)
        { %>
    <p>
        <span class="date"><%=item.date.ToString("dd.MM.yyyy") %></span>
        <br />
        <%=item.text %><span>&nbsp;</span>
    </p>
    <hr />+
    <% } %>
</asp:Content>
