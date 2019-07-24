<%@ Page Title="Статьи" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Articles.aspx.cs" Inherits="Rentoolo.Admin.Articles" %>

<%@ Import Namespace="Rentoolo.Model" %>
<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1><%: Title %></h1>
    </hgroup>
    <br />
    <a href="ArticleOne.aspx" title="Добавить новость">Добавить статью</a>
    <br />
    <br />
    <table class="basicTable">
        <tr>
            <th>Дата
            </th>
            <th>Текст
            </th>
            <th>Автор
            </th>
            <th></th>
            <th></th>
        </tr>
        <% foreach (Articles item in ListItems)
           {%>
        <tr>
            <td style="vertical-align: top;">
                <%= item.WhenDate.ToString("dd.MM.yyyy")%>
            </td>
            <td>
                <%= item.Text%>
            </td>
            <td>
                <%= DataHelper.GetUser(item.UserId).UserName%>
            </td>
            <td>
                <a href="ArticleOne.aspx?id=<%= item.Id%>">
                    <img src="/Images/icon_edit.png" alt="Редактировать" title="Редактировать">
                </a>
            </td>
            <td>
                <span style="cursor: pointer;" onclick="DeleteItem(<%=item.Id%>)">
                    <img src="/Images/delete.png" alt="Удалить" title="Удалить"></span>
            </td>
        </tr>
        <% } %>
    </table>
</asp:Content>
