<%@ Page Title="Рефералы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Referrals.aspx.cs" Inherits="Rentoolo.Admin.Referrals" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="/Scripts/jquery.tablesorter.min.js"></script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <br />
    <table class="basicTable">
        <thead>
            <tr>
                <th>Номер
                </th>
                <th>Реферер
                </th>
                <th>Реферал
                </th>
                <th>Дата регистрации
                </th>
            </tr>
        </thead>
        <tbody>
            <% for (int i = 0; ListItems != null && i < ListItems.Count; i++)
                {%>
            <tr>
                <td>
                    <%= i + 1%>
                </td>
                <td>
                    <a href="User.aspx?id=<%= ListItems[i].ReferrerUserId%>"><%= DataHelper.GetUser(ListItems[i].ReferrerUserId).UserName%></a>
                </td>
                <td>
                    <a href="User.aspx?id=<%= ListItems[i].ReferralUserId%>"><%= DataHelper.GetUser(ListItems[i].ReferralUserId).UserName%></a>
                </td>
                <td>
                    <%= ListItems[i].WhenDate.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm")%>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".basicTable").tablesorter({ dateFormat: "uk" });
        });
    </script>
</asp:Content>
