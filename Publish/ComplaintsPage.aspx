<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ComplaintsPage.aspx.cs" Inherits="Rentoolo.ComplaintsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <% foreach (var complaint in Complaints)
            { %>
                <div>
                    
                </div>
                
        <% } %>
    </div>
</asp:Content>
