<%@ Page Title="Ошибки" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Exceptions.aspx.cs" Inherits="Rentoolo.Admin.Exceptions" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1><%: Title %></h1>
    </hgroup>
    <table class="basicTable">
        <tr>
            <th>Номер</th>
            <th>Значение</th>
            <th>Дата</th>
        </tr>
        <% for (int i = 0; ListItems != null && i < ListItems.Count; i++)
           {%>
        <tr>
            <td>
                <%= ListItems.Count - i%>
            </td>
            <td>
                <%=ListItems[i].Value%>
            </td>
            <td>
                <%=ListItems[i].WhenDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
        </tr>
        <% } %>
    </table>
</asp:Content>