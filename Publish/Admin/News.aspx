<%@ Page Title="Управление. Новости" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="News.aspx.cs" Inherits="Rentoolo.Admin.News" %>

<%@ Import Namespace="Rentoolo.Model" %>
<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%: Title %></h2>

    <br />
    <a href="NewsOne.aspx" class="hrefOneNews" title="Добавить новость">Добавить новость</a>
    <br />
    <br />
    <table class="basicTable">
        <tr>
            <th>Дата
            </th>
            <th>Текст
            </th>
            <th>Отредактировано
            </th>
            <th>Автор
            </th>
            <th></th>
            <th></th>
        </tr>
        <% foreach (News item in list)
            {%>
        <tr>
            <td style="vertical-align: top;">
                <%= item.Date.ToString("dd.MM.yyyy")%>
            </td>
            <td>
                <%= item.Text%>
            </td>
            <td>
                <%= item.CreateDate.ToString("dd.MM.yyyy")%>
            </td>
            <td>
                <%= DataHelper.GetUser(item.AuthorId).UserName%>
            </td>
            <td>
                <a href="NewsOne.aspx?id=<%= item.Id%>">
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
