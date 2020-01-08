<%@ Page Title="Вы смотрели" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Watched.aspx.cs" Inherits="Rentoolo.Account.Watched" %>
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
                            htmlString += "<img src='" + v + "' style='height: 120px; width: 170px;' class='advert-img' alt='' />";
                        }
                    });

                $(this).html(htmlString);
            });

            $(".photoContainer").brazzersCarousel();

            $(".item-wrap__description-description").each(function (index) {
                var innerHtml = $(this).html();
                var length = 70;
                var trimmedHtml = innerHtml.length > length ?
                    innerHtml.substring(0, length - 3) + "..." :
                    innerHtml;
                $(this).html(trimmedHtml);
            });

            $(".item-wrap__like").click(function () {
                removeF($(this).parent().attr("aid"));
                $(this).parent().remove();
                var advertCount = parseInt($("#adverts-count").text());
                $("#adverts-count").text(advertCount - 1);
            });
        });

        function removeF(aId) {
            $.get("/Events.ashx?e=rf&id=" + aId);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="list-group media-list media-list-stream mb-4">
        <li class="media list-group-item p-4">
            <div class="media-body">
                <div class="media-heading">
                    <small class="float-right text-muted"><span id="adverts-count"><%=ListCount %></span> adverts</small>
                    <h6>Избранное:</h6>
                </div>
                <div class="media-body-inline-grid">
                    <%foreach (var item in ListItems)
                        { %>
                    <div class="list-item-wrap" style="display: none" aid="<%=item.Id%>">
                        <a href="Advert.aspx?id=<%=item.AdvertId%>" class="href-photoContainer" title="<%=item.Name%>">
                            <div class="photoContainer" data='<%=item.ImgUrls%>'></div>
                        </a>
                        <div class="item-wrap-content">
                            <div class="item-wrap-name"><a href="Advert.aspx?id=<%=item.AdvertId%>"><%=item.Name%></a></div>
                            <div class="item-wrap-cost"><%=item.Price%> ₽<%--<%=item.CurrencyAcronim%>--%></div>
                            <div class="item-wrap__description">
                                <p><span class="item-wrap__description-description" maxlength="20"><%=item.Description%></span></p>
                                <p><%=item.Category%></p>
                                <p><%=item.Address%></p>
                                <div class="item-wrap__data">Опубликовано: <%=item.CreatedAdverts.ToString("dd.MM.yyyy HH:mm")%></div>
                                <div class="item-wrap__data">Добавлено в избранное: <%=item.CreatedFavorites.ToString("dd.MM.yyyy HH:mm")%></div>
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
