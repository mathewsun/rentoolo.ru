<%@ Page Title="Статьи" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Articles.aspx.cs" Inherits="Rentoolo.Articles" %>

<%@ Import Namespace="Rentoolo.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h1><%: Title %></h1>
    <br />
    <% foreach (var item in ListArticles)
        { %>
    <p>
        <h2><a href="Article.aspx?id=<%=item.Id %>" title="<%=item.Head %>"><%=item.Head %></a></h2>
        <span class="date"><%=item.WhenDate.ToString("dd.MM.yyyy") %></span>
        <br />
        <%= Helper.TruncateLongString(item.Text, 300) %> <a href="Article.aspx?id=<%=item.Id %>" title="<%=item.Head %>">читать далее...</a><span>&nbsp;</span>
    </p>
    <hr />
    <% } %>
</asp:Content>
