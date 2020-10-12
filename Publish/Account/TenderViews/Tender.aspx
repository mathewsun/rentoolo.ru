<%@ Page Title="Тендеры" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tender.aspx.cs" Inherits="Rentoolo.Account.Tender" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .block-card{
            
            height: 100px;
            border: 2px solid black;
            border-radius: 25px;
            margin: 5px;
        }

        .grid-view{
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        .black-text{
            color: black;
        }

        .search-panel{
            width: 50%;
        }

        .medium-button{
            width: 20%;
        }


    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>

        <h5>
            Search by name:
        </h5>
        <form action="Tender.aspx" method="post">
            <input type="text" name="name" class="search-panel" />
            <input type="submit" value="search" class="medium-button" />
        </form>
        
        <div class="grid-view">

            <% foreach (var tender in tenders) { %>
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
