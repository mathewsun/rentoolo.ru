<%@ Page Title="Новости" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="News.aspx.cs" Inherits="Rentoolo.News" %>

<%@ Import Namespace="Rentoolo.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1><%: Title %></h1>
    </hgroup>
    <br />
    <% foreach (var item in ListNews)
        { %>
    <p>
        <span class="date"><%=item.Date.ToString("dd.MM.yyyy") %></span>
        <br />
        <%=item.Text %><span>&nbsp;</span>
    </p>
    <hr />
    <% } %>
</asp:Content>
