<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TenderInfo.aspx.cs" Inherits="Rentoolo.Account.TenderInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <a href="Tender.aspx">
            <h5>Вернуться к списку тендеров</h5>
        </a>
        <h2>Tender Info</h2>
        <div>
            <h4>
                <%= tender.Name %>
            </h4>
            <p>
                Description: 
                <%= tender.Description %>
            </p>
            <p>
                Created: <%= tender.Created %>
            </p>
            <p>
                Cost: <%= tender.Cost %>
            </p>

        </div>

       
    </div>
</asp:Content>
