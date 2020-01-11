<%@ Page Title="Device settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DeviceSettings.aspx.cs" Inherits="Rentoolo.Account.DeviceSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        $(document).ready(function () {

            // Size of browser viewport.
            var height1 = $(window).height();
            var width1 = $(window).width();

            // Size of HTML document (same as pageHeight/pageWidth in screenshot).
            var height2 = $(document).height();
            var width2 = $(document).width();

            // Screen size
            var height3 = window.screen.height;
            var width3 = window.screen.width;

            $('#window_height').text(height1);
            $('#window_width').text(width1);
            $('#document_height').text(height2);
            $('#document_width').text(width2);
            $('#window_screen_height').text(height3);
            $('#window_screen_width').text(width3);

            //alert("height1 = " + height1 + "; width1 = " + width1 + "; height2 = " + height2 + "; width2 = " + width2 + "; height3 = " + height3 + "; width3 = " + width3);


            $("#allCategorieslist").click(function () {
                if ($(".more-popup").is(":visible")) {
                    $(".more-popup").fadeOut(300);

                } else {
                    $(".more-popup").fadeIn(300);
                };
            });

            $(".item-wrap__like").click(function () {
                $(this).toggleClass('item-wrap__like-active');
            });

            getLocation();

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
    Size of browser viewport:
    <br />
    $(window).height() = <span id="window_height"></span>
    <br />
    $(window).width() = <span id="window_width"></span>
    <br />

    Size of HTML document (same as pageHeight/pageWidth in screenshot):
    <br />
    $(document).height() = <span id="document_height"></span>
    <br />
    $(document).width() = <span id="document_width"></span>
    <br />
    Screen size:
    <br />
    window.screen.height = <span id="window_screen_height"></span>
    <br />
    window.screen.width = <span id="window_screen_width"></span>

</asp:Content>
