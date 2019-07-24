<%@ Page Title="Пользователи" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="Rentoolo.Admin.Users" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="/Scripts/jquery.tablesorter.min.js"></script>
    <style type="text/css">
        .adminUsers {
            font-size: 90%; /* Размер шрифта */
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%: Title %></h2>

    <table class="basicTable adminUsers">
        <thead>
            <tr>
                <th>№
                </th>
                <th style="width: 150px;">Имя
                </th>
                <th>PublicId
                </th>
                <th>Рег.
                </th>
                <th>Послдн. вход
                </th>
                <th>Телефон
                </th>
                <th>
                </th>
                <th>Email
                </th>
                <th>
                </th>
                <th>
                </th>
            </tr>
        </thead>
        <tbody>
            <% for (int i = 0; List != null && i < List.Count; i++)
                {%>
            <tr>
                <td>
                    <%= List.Count - i%>
                </td>
                <td style="width: 150px;">
                    <a href="User.aspx?id=<%= List[i].UserId%>" title="<%= List[i].UserName%>"><%= Rentoolo.Model.Helper.TruncateLongString(List[i].UserName, 15)%></a>
                </td>
                <td>
                    <%= List[i].PublicId%>
                </td>
                <td>
                    <%= List[i].CreateDate.HasValue ? List[i].CreateDate.Value.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm").Replace(".","/") : ""%>
                </td>
                <td><%= List[i].LastActivityDate.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm").Replace(".","/")%></td>
                <td><%= List[i].Communication != null ? Rentoolo.Model.Helper.TruncateLongString(List[i].Communication, 12) : ""%></td>
                <td></td>
                <td>
                    <span title="<%= List[i].Email%>"><%= List[i].Email != null ? Rentoolo.Model.Helper.TruncateLongString(List[i].Email, 15) : ""%></span>
                </td>
                <td></td>
                <td></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <script type="text/javascript">
        $(document).ready(function () {

            $(".adminUsers").tablesorter({ dateFormat: "uk" });

            $("#columns").css("width", "1650px");
        });
    </script>
</asp:Content>
