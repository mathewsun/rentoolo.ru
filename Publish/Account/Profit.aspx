<%@ Page Title="Заработок" Language="C#" MasterPageFile="~/SiteBalance.Master" AutoEventWireup="true" CodeBehind="Profit.aspx.cs" Inherits="Rentoolo.Account.Profit" %>

<%@ Register Src="Menu.ascx" TagName="AccountMenu" TagPrefix="uc1" %>

<%@ Register Src="/Account/ManageTopUserControl.ascx" TagName="TopManageControl" TagPrefix="uc1" %>

<asp:Content ID="Content3" ContentPlaceHolderID="LeftMenu" runat="server">
    <uc1:AccountMenu ID="AccountMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="/Scripts/jquery.tablesorter.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc1:TopManageControl ID="TopManageMenu" runat="server" />
    <br />
    <hr />
    <br />
    <div>
        Ваша ссылка для привлечения рефералов - <strong>
            <asp:Label ID="LabelReferralLink" runat="server" /></strong>
    </div>
    <br />
    <hr />
    
</asp:Content>
