<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateExchangeItem.aspx.cs" Inherits="Rentoolo.Account.CreateExchangeItem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <input type="text" name="header" placeholder="header" />
        <input type="text" name="wanted" placeholder="wanted" />
        <input type="text" name="comment" placeholder="comment" />
        <asp:Button ID="ButtonCreate" runat="server" Text="create" OnClick="ButtonCreate_Click" />

    </div>
</asp:Content>
