<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="Rentoolo.UserProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>

        <div>
            <div>
                <%= AnotherUser.UserName %>
            </div>
        </div>
        <div>
            <a href="">перейти к диалогу: </a>
        </div>

    </div>
</asp:Content>
