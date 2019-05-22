<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="Operations.aspx.cs" Inherits="Rentoolo.Admin.Operations" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <table class="basicTable">
        <tr>
            <th>Пользователь
            </th>
            <th>Сумма
            </th>
            <th>Тип операции
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
                <a href="User.aspx?id=<%=List[i].UserId%>"><%=DataHelper.GetUser(List[i].UserId).UserName%></a>
            </td>
            <td>
                <%= List[i].Value.ToString("N2")%>
            </td>
            <td>
                <%= OperationTypes.GetName(List[i].Type)%>
            </td>
            <td>
                <%= List[i].Comment%>
            </td>
            <td>
                <%= List[i].WhenDate.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm")%>
            </td>
        </tr>
        <% } %>
    </table>
</asp:Content>
