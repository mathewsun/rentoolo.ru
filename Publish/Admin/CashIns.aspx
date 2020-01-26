<%@ Page Title="Пополнения" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CashIns.aspx.cs" Inherits="Rentoolo.Admin.CashIns" %>
<%@ Import Namespace="Rentoolo.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <table class="basicTable">
        <tr>
            <th>Номер</th>
            <th>Пользователь</th>
            <th>Сумма</th>
            <th>Способ</th>
            <th>Дата</th>
        </tr>
        <% for (int i = 0; list != null && i < list.Count; i++)
            {%>
        <tr>
            <td>
                <%= list.Count - i%>
            </td>
            <td>
                <a href="User.aspx?id=<%=list[i].UserId%>"><%= DataHelper.GetUser(list[i].UserId).UserName%></a>
            </td>
            <td>
                <%= list[i].Value%>
            </td>
            <td>
                <%= list[i].Sposob%>
            </td>
            <td>
                <%= list[i].WhenDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
        </tr>
        <% } %>
    </table>
</asp:Content>
