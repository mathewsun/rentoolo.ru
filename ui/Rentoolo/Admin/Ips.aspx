<%@ Page Title="Пользователи по ip" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ips.aspx.cs" Inherits="Rentoolo.Admin.Ips" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <table class="basicTable">
        <tr>
            <th>Номер
            </th>
            <th>Имя
            </th>
            <th>Количество
            </th>
            <th>Последний вход
            </th>
            <th>Клиент</th>
        </tr>
        <% for (int i = 0; List != null && i < List.Count; i++)
            {%>
        <tr>
            <td>
                <%= List.Count - i%>
            </td>
            <td>
                <a href="User.aspx?id=<%= List[i].UserName%>" title="<%= List[i].UserName%>"><%= List[i].UserName%></a>
            </td>
            <td>
                <%= List[i].Count%>
            </td>
            <td><%= List[i].WhenLastDate.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm")%></td>
            <td><%= List[i].Client == 0 ? "Сайт" : "Клиент"%></td>
        </tr>
        <% } %>
    </table>

</asp:Content>
