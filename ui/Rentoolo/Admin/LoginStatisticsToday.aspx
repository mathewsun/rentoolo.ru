<%@ Page Title="Статистика посещений клиента сегодня" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LoginStatisticsToday.aspx.cs" Inherits="Rentoolo.Admin.LoginStatisticsToday" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="/Scripts/jquery.tablesorter.min.js"></script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <h1><%: Title %></h1>
    <hr />
    Статистика приложений:
    <br />
    <table class="basicTable loginStatisticsTodayTable">
        <thead>
            <tr>
                <th></th>
                <th>Пользователь
                </th>
                <th>Крайнее обращение
                </th>
                <th>Количество
                </th>
                <th>Версия
                </th>
                <th>С таким же ip</th>
                <th></th>
                <th>Ip
                </th>
            </tr>
        </thead>
        <tbody>
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
                    <%=ListDesctop[i].WhenLastDate.ToString("dd.MM.yyyy HH:mm")%>
                </td>
                <td>
                    <%=ListDesctop[i].Count%>
                </td>
                <td>
                    <%=ListDesctop[i].Version%>
                </td>
                <td>
                    <%= DataHelper.GetLoginStatisticByIp(ListDesctop[i].Ip)%>
                </td>
                <td></td>
                <td>
                    <a href="Ips.aspx?ip=<%=ListDesctop[i].Ip%>"><%= ListDesctop[i].Ip %></a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".loginStatisticsTodayTable").tablesorter({
                dateFormat: "uk"
            });
        });
    </script>
</asp:Content>
