<%@ Page Title="Аукционы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Auction.aspx.cs" Inherits="Rentoolo.Account.Auction" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="LabelName" runat="server" Text="Название аукциона:"></asp:Label>
    

    <br />
    <asp:TextBox ID="TextBoxName" ClientIDMode="Static" runat="server" Width="400px"></asp:TextBox>
    <br />

    <asp:Image ID="Image1" runat="server" Width="404px" />
    <br />
    <asp:Label ID="LabelDescription"  runat="server" Text="Описание:"></asp:Label>
    <br />
    <asp:TextBox ID="TextBoxDescription" ClientIDMode="Static" runat="server" Rows="4" TextMode="MultiLine" Width="400px"></asp:TextBox>
    <br />
    <br />
     <asp:Label ID="LabelPrice" runat="server" Text="Начальная цена:"></asp:Label>
    <asp:TextBox ID="TextBoxPrice" runat="server" Width="81px"></asp:TextBox>

    <br />
    <br />
    <asp:Button ID="ButtonSave" runat="server" Text="Добавить" OnClick="ButtonSave_Click" />
</asp:Content>

