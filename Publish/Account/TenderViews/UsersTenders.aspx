<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UsersTenders.aspx.cs" Inherits="Rentoolo.Account.TenderViews.UsersTenders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h3>
            Мои тендеры
        </h3>
        <div>


            <% foreach (var tender in Tenders)
               { %>
                    
                   <div class="block-card">
                        <a href="TenderInfo.aspx?id=<%=tender.Id %>">
                            <h4> <%= tender.Name %> </h4>
                            <div class="black-text">
                                Description: 
                                <%= tender.Description %>
                            </div>
                        </a>
                   </div>
                
            <% } %>
        </div>
    </div>
</asp:Content>
