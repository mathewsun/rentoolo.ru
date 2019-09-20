<%@ Page Title="Избранное" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Favorites.aspx.cs" Inherits="Rentoolo.Favorites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="/assets/js/jquery-2.2.4.js"></script>
    <link href="/assets/css/jQuery.Brazzers-Carousel.css" rel="stylesheet">
    <script src="/assets/js/jQuery.Brazzers-Carousel.js"></script>

    <script>
        $(document).ready(function () {
            $(".photoContainer").each(function (index) {
                var htmlString = '';
                var imgUrls = $(this).attr("data");
                JSON.parse(imgUrls,
                    function (k, v) {
                        if (k != "") {
                            htmlString += "<img src='" + v + "' style='height: 275px; width: 275px;' alt='' />";
                        }
                    });

                $(this).html(htmlString);
            });

            $(".photoContainer").brazzersCarousel();

            if (width3 < 512) {
                $(".href-photoContainer").attr("href", "#");
            }

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <ul class="list-group media-list media-list-stream mb-4">

        <li class="media list-group-item p-4">

            <div class="media-body">
                <div class="media-heading">
                    <small class="float-right text-muted"><%=ListCount %> adverts</small>
                    <h6>Избранное:</h6>
                </div>

                <div class="media-body-inline-grid">
                    <%foreach (var item in ListItems)
                        { %>
                    <div class="list-item-wrap" style="display: none">
                        <a href="Advert.aspx?id=<%=item.Id%>" class="href-photoContainer" title="<%=item.Name%>">
                            <div class="photoContainer" data='<%=item.ImgUrls%>'></div>
                        </a>
                        <div class="item-wrap-content">
                            <div class="item-wrap-name"><a href="Advert.aspx?id=<%=item.Id%>"><%=item.Name%></a></div>
                            <div class="item-wrap-cost"><%=item.Price%> ₽<%--<%=item.CurrencyAcronim%>--%></div>
                            <div class="item-wrap__description">
                                <p><%=item.Category%></p>
                                <p><%=item.Address%></p>
                                <div class="item-wrap__data"><%=item.CreatedAdverts.ToString("dd.MM.yyyy HH:mm")%></div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Удалить из Избранного"></div>
                    </div>
                    <%} %>
                </div>
            </div>
        </li>


    </ul>

</asp:Content>
