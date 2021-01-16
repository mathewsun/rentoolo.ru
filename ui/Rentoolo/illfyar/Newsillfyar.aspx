<%@ Page Title="Новости illfyar" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Newsillfyar.aspx.cs" Inherits="Rentoolo.illfyar.Newsillfyar" %>
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
        <span class="date"><%=item.Date.ToString("dd.MM.yyyy") %></span>
        <br />
        <%=item.Text %><span>&nbsp;</span>
    </p>
    <hr />
    <% } %>

</asp:Content>

