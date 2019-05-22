<%@ Page Title="Управление" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Rentoolo.Admin.Admin" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1><%: Title %></h1>
    <br />
    <br />
    Зарегистрировано пользователей: <%=DataHelper.GetAllUsersCount() %>
    <br />
    <br />
    <table class="basicTable middle">
        <tr>
            <td>Посетителей сайта за час</td>
            <td><%=DataHelper.GetLoginStatisticLastHourActive() %></td>
        </tr>
        <tr>
            <td>Посетителей сайта за сутки</td>
            <td><%=DataHelper.GetLoginStatisticLastDayActive() %></td>
        </tr>
    </table>

    <div class="leftMenuItems">
        <div>
            <asp:HyperLink ID="HyperLink14" NavigateUrl="Admin.aspx" runat="server">Управление</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLinkCabinet" NavigateUrl="Users.aspx" runat="server">Пользователи</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLink1" NavigateUrl="News.aspx" runat="server">Новости</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLink9" NavigateUrl="Articles.aspx" runat="server">Статьи</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLink13" NavigateUrl="Exceptions.aspx" runat="server">Ошибки</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLink6" NavigateUrl="Operations.aspx" runat="server">Операции</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLink4" NavigateUrl="LoginStatistics.aspx" runat="server">Статистика посещений</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLink16" NavigateUrl="LoginStatisticsToday.aspx" runat="server">Стат. посщ. клиента сегодня</asp:HyperLink>
        </div>
        <div>
            <asp:HyperLink ID="HyperLink15" NavigateUrl="DatabaseTables.aspx" runat="server">Таблицы в БД</asp:HyperLink>
        </div>
        <div class="clear"></div>
    </div>

</asp:Content>
