<%@ Page Title="Аукционы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Auctions.aspx.cs" Inherits="Rentoolo.Auctions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script src="/assets/js/jquery-2.2.4.js"></script>
    <link href="/assets/css/jQuery.Brazzers-Carousel.css" rel="stylesheet">
    <script src="/assets/js/jQuery.Brazzers-Carousel.js"></script>
    <script src="assets/js/popper.min.js"></script>

    <script>
        $(document).ready(function () {

            var height1 = $(window).height();
            var width1 = $(window).width();

            // Size of HTML document (same as pageHeight/pageWidth in screenshot).
            var height2 = $(document).height();
            var width2 = $(document).width();

            // Screen size
            var height3 = window.screen.height;
            var width3 = window.screen.width;

            $(".item-wrap__like").click(function () {
                $(this).toggleClass('item-wrap__like-active');
            });

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

            if (width1 < 512 || width2 < 512 || width3 < 512) {
                $(".href-photoContainer").attr("href", "#");
            }

            $(".item-wrap__description-description").each(function (index) {
                var innerHtml = $(this).html();
                var length = 70;
                var trimmedHtml = innerHtml.length > length ?
                    innerHtml.substring(0, length - 3) + "..." :
                    innerHtml;
                $(this).html(trimmedHtml);
            });
        });

        $(window).resize(function () {
            // Size of browser viewport.
            var height1 = $(window).height();
            var width1 = $(window).width();

            // Size of HTML document (same as pageHeight/pageWidth in screenshot).
            var height2 = $(document).height();
            var width2 = $(document).width();

            // Screen size
            var height3 = window.screen.height;
            var width3 = window.screen.width;

            if (width1 < 512 || width2 < 512 || width3 < 512) {
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
                                    <small class="float-right text-muted"><%=AuctionsCount %> аукционов</small>
                                    <h6>Аукционы:</h6>
                                </div>
                <div class="media-body-inline-grid" data-grid="images">
                    <!--<div class="row"> - эта строка не давала отобразиться картинкам, почему? <-->
                    <%foreach (var item in ListItems)
                        { %>
                    <div class="item-wrap" style="display: none" aid="<%=item.Id%>">
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
                    </div>

                    <%} %>
                </div>
            </div>
        </li>
    </ul>

</asp:Content>
