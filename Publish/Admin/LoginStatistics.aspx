<%@ Page Title="Статистика посещений" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LoginStatistics.aspx.cs" Inherits="Rentoolo.Admin.LoginStatistics" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <h1><%: Title %></h1>
    <hr />
    Статистика приложений:
    <br />
    <table class="basicTable">
        <tr>
            <th></th>
            <th>Пользователь
            </th>
            <th>Ip
            </th>
            <th>Крайнее обращение
            </th>
            <th>Количество
            </th>
            <th>Версия
            </th>
            <th>С таким же ip</th>
        </tr>
        <% for (int i = 0; i < ListDesctop.Count; i++)
           { %>
        <tr>
            <td>
                <%=i%>
            </td>
            <td>
                <a href="User.aspx?id=<%=ListDesctop[i].UserName%>"><%=ListDesctop[i].UserName%></a>
            </td>
            <td>
                <a href="Ips.aspx?ip=<%=ListDesctop[i].Ip%>"><%= ListDesctop[i].Ip %></a>
            </td>
            <td>
                <%=ListDesctop[i].WhenLastDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
            <td>
                <%=ListDesctop[i].Count%>
            </td>
            <td>
                <%=ListDesctop[i].Version%>
            </td>
            <td><%= DataHelper.GetLoginStatisticByIp(ListDesctop[i].Ip)%></td>
        </tr>
        <% } %>
    </table>
    
    <hr />
    Статистика сайта:
    <br />
    <table class="basicTable">
        <tr>
            <th></th>
            <th>Пользователь
            </th>
            <th>Ip
            </th>
            <th>Крайнее обращение
            </th>
            <th>Количество
            </th>
            <th>С таким же ip</th>
        </tr>
        <% for (int i = 0; i < ListSite.Count; i++)
           { %>
        <tr>
            <td>
                <%=i%>
            </td>
            <td>
                <a href="User.aspx?id=<%=ListSite[i].UserName%>"><%=ListSite[i].UserName%></a>
            </td>
            <td>
                <a href="Ips.aspx?ip=<%=ListSite[i].Ip%>"><%= ListSite[i].Ip %></a>
            </td>
            <td>
                <%=ListSite[i].WhenLastDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
            <td>
                <%=ListSite[i].Count%>
            </td>
            <td><%= DataHelper.GetLoginStatisticByIp(ListSite[i].Ip)%></td>
        </tr>
        <% } %>
    </table>

</asp:Content>
