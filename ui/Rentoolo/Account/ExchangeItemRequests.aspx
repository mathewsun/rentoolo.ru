<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ExchangeItemRequests.aspx.cs" Inherits="Rentoolo.Account.ExchangeItemRequests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <div>
            това <br />
            <h5>
                <%= Advert.Name %> <br />
                <%= Advert.Description %>
            </h5>
        </div>
        <h4>
            Запросы на обмен:
        </h4>
        <div>

            <% foreach (var req in ItemRequests)
                {%>
                   <a href="">
                       <%= req.Comment %>
                   </a>
                    
                    
            <% } %>

        </div>
    </div>
</asp:Content>
