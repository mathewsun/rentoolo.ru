<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WinedTenderRequest.aspx.cs" Inherits="Rentoolo.Account.TenderViews.WinedTenderRequest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h3>
            Выигравший запрос на тендер:
        </h3>
        <div>
            Имя поставщика: <%= TReq.ProviderName %>
        </div>
    </div>
</asp:Content>
