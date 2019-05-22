<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Menu.ascx.cs" Inherits="Rentoolo.Account.Menu" %>

<div class="leftMenuItems">
    <div>
        <asp:HyperLink ID="HyperLinkCabinet" NavigateUrl="Cabinet.aspx" runat="server">Кабинет</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLinkReferrals" NavigateUrl="Referrals.aspx" runat="server">Рефералы</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLinkOperationsList" NavigateUrl="Operations.aspx" runat="server">Операции</asp:HyperLink>
    </div>
    <div>
        <asp:HyperLink ID="HyperLink1" NavigateUrl="CashIn.aspx" runat="server">Пополнить баланс</asp:HyperLink>
    </div>
    <div class="clear"></div>
</div>
