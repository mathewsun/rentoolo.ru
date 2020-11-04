<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateComplaint.aspx.cs" Inherits="Rentoolo.CreateComplaint" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>

        <form method="post">
            Message: <br />
            <input name="message" type="text" /> <br />
            <input name="complaintType" type="text" /> <br />
            <asp:Button ID="ButtonCreateComplaint" runat="server" OnClick="ButtonCreateComplaint_Click" Text="Create complaint" />
        </form>

        
    </div>
</asp:Content>
