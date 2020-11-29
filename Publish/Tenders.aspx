<%@ Page Title="Тендеры" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tenders.aspx.cs" Inherits="Rentoolo.Tenders" %>
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
            grid-template-columns: 40% 40%;
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

        .item-without-img-wrap{
            display: inline-block;
            margin-bottom: 10px;
            margin-right: 10px;
            vertical-align: bottom;
            overflow: hidden; 
        }


    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>

        <h5>
            Search by name:
        </h5>
            <input type="text" name="name" class="search-panel" />
            <input type="submit" value="search" class="medium-button" />


        <div>
            TCount: <%= TendersList.Count %>
        </div>


        <div class="grid-view">

            <% foreach (var tender in TendersList)
                { %>
                    <div class="item-wrap item-without-img-wrap">
                        <h4>
                            <a href="Tender.aspx?id=<%= tender.Id %>">
                                <%= tender.Name %>
                            </a>
                        </h4>
                        <h4>
                            <%= tender.Cost %> ₽
                             
                        </h4>
                        <div>
                            <%= tender.Description %>
                        </div>
                        <div>
                            <%=tender.Created.ToString().Split(' ')[0] %>
                        </div>

                    </div>



            <%--<div class="item-wrap" style="display: none" aid="<%=item.Id%>">
                        <a href="Auction.aspx?id=<%=item.Id%>" class="href-photoContainer" title="<%=item.Name%>">
                            <div class="photoContainer" data='<%=item.ImgUrls%>'></div>
                        </a>
                        <div class="item-wrap__wrap ">
                            <div class="item-wrap__name"><a href="Auction.aspx?id=<%=item.Id%>"><%=item.Name%></a></div>
                            <div class="item-wrap__description">
                                <p><span class="item-wrap__description-description" maxlength="20"><%=item.Description%></span></p>
                                <div class="item-wrap__data"><%=item.Created.ToString("dd.MM.yyyy HH:mm")%></div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                    </div>--%>


            <% } %>

        </div>
        
        <div >

            <% foreach (var tender in TendersList) { %>
                   <div class="item-wrap" style="display: none" >
                       AAA
                        <a href="Tender.aspx?id=<%=tender.Id %>">
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
