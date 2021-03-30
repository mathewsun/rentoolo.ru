<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Advert.aspx.cs" Inherits="Rentoolo.Advert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="assets/css/jQuery.Brazzers-Carousel.css" rel="stylesheet">
    <script src="/assets/js/jQuery.Brazzers-Carousel.js"></script>
    <script src="/assets/js/jsonUtils.js?2"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>

    <style>
        div.button {
          display:inline-block;
          -webkit-appearance:button;
          padding:3px 8px 3px 8px;
          font-size:13px;
          position:relative;
          cursor:context-menu;
          box-shadow: 0 0 5px -1px rgba(0,0,0,0.2);
          border:1px solid #CCC;
          background:#DDD;
        }

        div.button:active {
            color:red;
            box-shadow: 0 0 5px -1px rgba(0,0,0,0.6);
        }

        .like{
            width: 40px;
            height: 40px;
        }

        .dislike{
            width: 40px;
            height: 40px;
            transform: rotate(180deg);
        }
    </style>

    <script>
        $(document).ready(function () {
            $.get("/assets/json/categories.json", function (data) {
                var category = findJsonElementById(data, <%=AdvertItem.Category%>);
        
                if (category !== undefined) {
                    $("#category").html(category.name_ru);
                }
            });

            $(".photoContainer").each(function (index) {
                var htmlString = '';
                var imgUrls = $(this).attr("data");
                JSON.parse(imgUrls,
                    function (k, v) {
                        if (k != "") {
                            htmlString += "<img src='" + v + "' style='height: 600px; width: 700px;' alt='' />";
                        }
                    });

                $(this).html(htmlString);
            });

            $(".photoContainer").brazzersCarousel();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="advert">
        <div class="media-body-inline-grid" data-grid="images">
            <div class="photoContainer" data='<%=AdvertItem.ImgUrls%>'></div>
        </div>
        <div class="additem-category">
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span>Категория</span>
            </div>
            <div class="additem-right additem__way" cid="1001">
                <a href="#" id="category">Category</a>
                <input type="hidden" id="category_hidden" value="1001" runat="server" />
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Название объявления</span>
            </div>
            <div class="additem-right">
                <%=AdvertItem.Name %>
            </div>
        </div>

        <div class="additem-category additem-text__wrap">
            <div class="additem-left">
                <span class="additem-title">Описание объявления</span>
            </div>
            <div class="additem-right advert-description">
                <%=AdvertItem.Description %>
            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Цена</span>
            </div>
            <div class="additem-right">
                <%=AdvertItem.Price %>
                <span class="price__value">₽</span>
            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Видео с Youtube</span>
            </div>
            <div class="additem-right additem__video">
                <%=AdvertItem.YouTubeUrl %>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left additem-contact">
                Контактная информация
            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left additem-contact">
                <a href="/UserProfile.aspx?id=<%=AdvertItem.CreatedUserId %>" >
                    <%= AnotherUser.UserName %>
                </a>
            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Место сделки</span>
            </div>
            <div class="additem-right additem-place">
                <%=AdvertItem.Address %>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left ">
            </div>
            <div class="additem-right additem-map">
                <div class="additem-map">
                    <div id="map"></div>
                    <script>
                        // Initialize and add the map
                        function initMap() {
                            // The location of Uluru
                            var uluru = { lat: 55.751244, lng: 37.618423 };
                            // The map, centered at Uluru
                            var map = new google.maps.Map(
                                document.getElementById('map'), { zoom: 16, center: uluru });
                            // The marker, positioned at Uluru
                            var marker = new google.maps.Marker({ position: uluru, map: map });
                        }
                    </script>
                    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAEM6pBamtfcOxQiIHbO9HY76xvNiUxgIo&callback=initMap" async defer></script>
                </div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Телефон</span>
            </div>
            <div class="additem-right additem-phone">
                <%=AdvertItem.Phone %>
            </div>
        </div>
        <div>
            <h5>
                <a href="CreateComplaint.aspx?complaintObjectType=1&userRecivier=<%=AdvertItem.CreatedUserId %>&objectId=<%=AdvertItem.Id %>">
                    Пожаловаться
                </a>
            </h5>
        </div>
    </div>
</asp:Content>
