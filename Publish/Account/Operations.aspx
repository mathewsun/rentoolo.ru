<%@ Page Title="История" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Operations.aspx.cs" Inherits="Rentoolo.Account.Operations" %>

<%@ Import Namespace="Rentoolo.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%: Title %></h2>

    <table class="basicTable">
        <tr>
            <th>Дата
            </th>
            <th>Сумма
            </th>
            <th>Событие
            </th>
            <th>Комментарий
            </th>
        </tr>
        <% for (int i = 0; List != null && i < List.Count; i++)
            {%>
        <tr>
            <td>
                <%= List[i].WhenDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
            <td class="center">
                <%= List[i].Value.ToString("N2")%>
            </td>
            <td>
                <%= OperationTypes.GetName(List[i].Type)%>
            </td>
            <td>
                <%= List[i].Comment%>
            </td>
        </tr>
        <% } %>
    </table>

    <script type="text/javascript">
        jQuery(document).ready(function ($) {
            var topMenu = $("#top-navigation"),
            menuItems = topMenu.find("a");
            menuItems.parent().removeClass("active");
            menuItems.filter("[id*='OperationsLink']").parent().addClass("active");
            window.history.replaceState(null, null, window.location.pathname);
        });
    </script>
</asp:Content>
