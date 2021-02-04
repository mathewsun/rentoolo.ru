<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="JoinChat.aspx.cs" Inherits="Rentoolo.ChatFront.JoinChat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <div style="margin-top: 120px; margin-left: auto; margin-right: auto;" >



            <span class="text-info"></span>
            <asp:Button ID="Button1" CssClass="btn-info" runat="server" Text="присоединится" OnClick="Button1_Click" />
        </div>
    </div>
</asp:Content>
