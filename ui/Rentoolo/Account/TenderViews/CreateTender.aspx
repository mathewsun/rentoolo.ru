<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateTender.aspx.cs" Inherits="Rentoolo.Account.TenderViews.CreateTender" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <form>
        <asp:TextBox ID="TextBoxTName" runat="server" ToolTip="название тендера"></asp:TextBox>
        <asp:TextBox ID="TextBoxTDescription" runat="server" ToolTip="описание" ></asp:TextBox>
        <asp:TextBox ID="TextBoxTCost" runat="server" ToolTip="стоимость" ></asp:TextBox>
        <asp:Button ID="ButtonAddRequest" runat="server" Text="Создать тендер" OnClick="ButtonAddTender_Click" />


    </form>



</asp:Content>
