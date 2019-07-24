<%@ Page Title="Таблицы базы данных" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DatabaseTables.aspx.cs" Inherits="Rentoolo.Admin.DatabaseTables" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <h1><%: Title %></h1>
    <hr />
    Записи в таблицах:
    <br />
    <table class="basicTable">
        <tr>
            <th>№</th>
            <th>Таблица
            </th>
            <th>Количество
            </th>
        </tr>
        <% for (int i = 0; i < ListCounts.Count; i++)
           { %>
        <tr>
            <td>
                <%=i%>
            </td>
            <td><%= ListCounts[i].TableName%></td>
            <td><%= ListCounts[i].RowCount%></td>
        </tr>
        <% } %>
    </table>

</asp:Content>
