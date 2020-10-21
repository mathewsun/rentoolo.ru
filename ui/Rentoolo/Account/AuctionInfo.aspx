<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AuctionInfo.aspx.cs" Inherits="Rentoolo.Account.AuctionInfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <div>
            <a href="AuctionRequests.aspx?id=<%= AuctionItem.Id %>" >
                Requests for this auction
            </a>
        </div>
        <div>

            Name: <%= AuctionItem.Name %> <br />
            Price: <%= AuctionItem.StartPrice %> <br />
            Created: <%= AuctionItem.Created %> <br />
            <%= AuctionItem.Description %> <br />

        </div>



        <div>
            <h6>Create auction request</h6>
            <asp:TextBox ID="TextBox1" runat="server" ToolTip="name"></asp:TextBox>
            <asp:TextBox ID="TextBox2" runat="server" ToolTip="price"></asp:TextBox>
            <asp:TextBox ID="TextBox3" runat="server" ToolTip="description"></asp:TextBox>
            <br />
            <div>
                Data end: <br />
                <asp:TextBox ID="TextBoxDateEnd" runat="server"></asp:TextBox>
            </div>




            <asp:Button ID="ButtonCreateAuctionRequest" runat="server" Text="Create auction request" OnClick="ButtonCreateAuctionRequest_Click" />

        </div>

    </div>
</asp:Content>
