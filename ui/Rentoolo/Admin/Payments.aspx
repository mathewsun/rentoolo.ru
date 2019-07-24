<%@ Page Title="Переводы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Payments.aspx.cs" Inherits="Rentoolo.Admin.Payments" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <table class="basicTable">
        <tr>
            <th>Кто перевел
            </th>
            <th>Кому перевели
            </th>
            <th>Сумма
            </th>
            <th>Комментарий
            </th>
            <th>Дата
            </th>
        </tr>
        <% for (int i = 0; List != null && i < List.Count; i++)
            {%>
        <tr>
            <td>
                <a href="User.aspx?id=<%=List[i].UserIdSender%>"><%=DataHelper.GetUser(List[i].UserIdSender).UserName%></a>
            </td>
            <td>
                <a href="User.aspx?id=<%=List[i].UserIdRecepient%>"><%=DataHelper.GetUser(List[i].UserIdRecepient).UserName%></a>
            </td>
            <td>
                <%= List[i].Value.ToString("N2")%>
            </td>
            <td>
                <%= List[i].Comment%>
            </td>
            <td>
                <%= List[i].WhenDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
        </tr>
        <% } %>
    </table>
</asp:Content>
