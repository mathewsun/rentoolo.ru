<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserComplaintView.aspx.cs" Inherits="Rentoolo.Account.UserComplaintView" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        Message: <%= Complaint.Message %>
    </div>
</asp:Content>
