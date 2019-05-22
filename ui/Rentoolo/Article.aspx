<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Article.aspx.cs" Inherits="Rentoolo.Article" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <title><%=ArticleItem.Head %> - SmmZilla</title>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h1><%=ArticleItem.Head %></h1>
    <p>
        <a href="Articles.aspx">назад к списку</a>
    </p>
    <p>
        <%=ArticleItem.WhenDate.ToString("dd.MM.yyyy") %>
    </p>
    <p>
        <%=ArticleItem.Text %>
    </p>
</asp:Content>
