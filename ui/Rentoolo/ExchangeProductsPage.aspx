<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ExchangeProductsPage.aspx.cs" Inherits="Rentoolo.ExchangeProductsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <div>
            <input type="text" name="search" />
            <asp:Button ID="ButtonSearch" runat="server" Text="search" OnClick="ButtonSearch_Click" />

        </div>
        <div>

            <% foreach (var item in ExchangeItems)
                { %>
                    
                    <div>
                        <h4>
                            <%= item.Name %>
                        </h4>
                    </div>

            <% } %>

        </div>
        
    </div>
</asp:Content>
