<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SelectAdvertToExchange.aspx.cs" Inherits="Rentoolo.Account.SelectAdvertToExchange" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .rowed-grid {
            width: 100%;
            display: grid;
            grid-template-columns: 40% 40%;
            grid-row-gap: 5px;
        }

        .overflow-text-area{
              overflow: hidden;
              text-overflow: ellipsis;
              display: -moz-box;
              -moz-box-orient: vertical;
              display: -webkit-box;
              -webkit-line-clamp: 3;
              -webkit-box-orient: vertical;
              line-clamp: 3;
              box-orient: vertical;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>


        <div class="media list-group-item p-4 rowed-grid">

                            <div class="media-body">
                                <div class="media-heading">
                                    <small class="float-right text-muted"><%=UserAdverts.Count %> объявлений</small>
                                    <h6>Бытовая электроника:</h6>
                                </div>

                                <div class="media-body-inline-grid" data-grid="images">
                                    <%foreach (var item in UserAdverts)
                                        { %>
                                    <div class="item-wrap" style="display: none" aid="<%=item.Id%>">
                                        <a href="CreateExchangeItem.aspx?id=<%=item.Id%>" class="href-photoContainer" title="<%=item.Name%>">
                                            <div class="photoContainer" data='<%=item.ImgUrls%>'></div>
                                        </a>
                                        <div class="item-wrap__wrap ">
                                            <div class="item-wrap__name"><a href="CreateExchangeItem.aspx?id=<%=item.Id%>"><%=item.Name%></a></div>
                                            <div class="item-wrap__cost"><%=item.Price%> ₽<%--<%=item.CurrencyAcronim%>--%></div>
                                            <div class="item-wrap__description">
                                                <p><span class="item-wrap__description-description overflow-text-area" maxlength="20" ><%=item.Description%></span></p>
                                                <p><%=item.Category%></p>
                                                <p><%=item.Address%></p>
                                                <div class="item-wrap__data"><%=item.Created.ToString("dd.MM.yyyy HH:mm")%></div>
                                            </div>
                                        </div>
                                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                                    </div>
                                    <%} %>
                                </div>
                            </div>


                        </div>



    </div>
</asp:Content>
