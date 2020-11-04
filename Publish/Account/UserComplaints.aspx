<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserComplaints.aspx.cs" Inherits="Rentoolo.Account.UserComplaints" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <% foreach (var item in ComplaintList)
            { %>
            <div>
                <a href="UserComplaintView.aspx?id=<%=item.Id %>">
                    From: <%= item.UserSenderName %> <br />
                </a>
            </div>
        <%} %>
    </div>
</asp:Content>
