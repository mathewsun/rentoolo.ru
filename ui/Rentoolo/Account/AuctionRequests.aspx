<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AuctionRequests.aspx.cs" Inherits="Rentoolo.AuctionRequests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h5>
            Auction Requests
        </h5>
        <div>

            <% foreach(var item in AuctionRequestList){  %>
                
                <div>
                    Name : <%= item.Name %> <br />
                    Price: <%= item.Price %> <br />
                    Description: <%= item.Description %>

                </div>
                
            <% } %>

        </div>
    </div>
</asp:Content>
