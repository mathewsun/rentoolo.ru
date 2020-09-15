<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UsersTenderRequests.aspx.cs" Inherits="Rentoolo.Account.TenderViews.UsersTenderRequests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h3>
            Список моих заявок на тендер:
        </h3>

        <div>
        <div>

            <% foreach (var t in TenderRequests)
               { %>
                    <a href="TenderRequestView.aspx?id=<%=t.Id %>">
                    Поставщик: <%= t.ProviderName %> <br />
                    Цена: <%= t.Cost %> <br />
                    Описание: <%= t.Description %> <br />
                    </a>
            <% } %>

        </div>
            
        
        </div>
    </div>
</asp:Content>
