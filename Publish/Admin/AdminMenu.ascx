<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdminMenu.ascx.cs" Inherits="Rentoolo.Admin.AdminMenu" %>

<div class="leftMenuItems">
    <div>
        <asp:HyperLink ID="HyperLink14" NavigateUrl="Admin.aspx" runat="server">Управление</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLinkCabinet" NavigateUrl="Users.aspx" runat="server">Пользователи</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLink10" NavigateUrl="CashIns.aspx" runat="server">Пополнения</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLink8" NavigateUrl="Referrals.aspx" runat="server">Рефералы</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLink1" NavigateUrl="News.aspx" runat="server">Новости</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLink9" NavigateUrl="Articles.aspx" runat="server">Статьи</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLink2" NavigateUrl="Events.aspx" runat="server">События</asp:HyperLink>
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
