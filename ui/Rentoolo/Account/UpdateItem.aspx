<%@ Page Title="Подать объявление" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UpdateItem.aspx.cs" Inherits="Rentoolo.Account.UpdateItem" validateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        #map {
            height: 300px;
            width: 100%;
        }
    </style>
    <script src="/assets/js/dropzone/dropzone.js"></script>
    <link href="/assets/js/dropzone/dropzone.css" rel="stylesheet">
    <link href="/assets/js/dropzone/basic.css" rel="stylesheet">
    <script src="/assets/js/jsonUtils.js?2"></script>

    <script>
        $(document).ready(function () {
            $("div#mdropzone").dropzone({
                url: "/api/upi",
                addRemoveLinks: true,
                resizeWidth: 800,
                resizeHeight: 600,
                resizeMethod: 'contain',
                resizeQuality: 1.0,
                dictDefaultMessage: "Add photos",
                success: function (file, response) {
                    var filaName = response;
                    file.previewElement.classList.add("dz-success");
                    $("#my-dropzone").append($('<input type="hidden" name="AdvertPhotos" ' + 'value="' + filaName + '">'));
                }
            });

            setLocation();

            var wto;
            $("#additem_place").change(function () {
                clearTimeout(wto);
                wto = setTimeout(function () {

                    var address = $("#additem_place").val();

                    var address = address.split(' ').join('+');

                    var googleUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=AIzaSyAEM6pBamtfcOxQiIHbO9HY76xvNiUxgIo";

                    $.get(googleUrl, function (data) {

                        var firstResult = data.results[0];

                        var latlng = firstResult.geometry.location.lat + ',' + firstResult.geometry.location.lng;

                        var mapCenter = { lat: firstResult.geometry.location.lat, lng: firstResult.geometry.location.lng };

                        document.getElementById("latgeo").value = firstResult.geometry.location.lat;
                        document.getElementById("lnggeo").value = firstResult.geometry.location.lng;

                        var map = new google.maps.Map(document.getElementById('map'), { zoom: 17, center: mapCenter });
                        // The marker, positioned at Uluru
                        var marker = new google.maps.Marker({ position: mapCenter, map: map });
                    });
                }, 1000);
            });

            $.get("/assets/json/categories.json?4", function (data) {

                var category = '<%=CategoryId%>';

                var strFirstCategory = category.substring(0, 2);

                var firstCategory = findJsonElementById(data, strFirstCategory);

                if (firstCategory.name_ru !== undefined) {
                    $("#category").html(firstCategory.name_ru);
                }
                else {
                    $("#category").html(firstCategory.name);
                }

                var strSecondCategory = category.substring(0, 4);

                if (strSecondCategory !== undefined) {
                    if (strSecondCategory == strFirstCategory) return;
                    var secondCategory = findJsonElementById(data, strSecondCategory);

                    if (secondCategory.name_ru !== undefined) {
                        $("#category").append("&nbsp;/&nbsp;" + secondCategory.name_ru);
                    }
                    else {
                        $("#category").append("&nbsp;/&nbsp;" + secondCategory.name);
                    }
                }

                var strThirdCategory = category.substring(0, 6);

                if (strThirdCategory !== undefined) {
                    if (strThirdCategory == strFirstCategory) return;
                    var thirdCategory = findJsonElementById(data, strThirdCategory);

                    if (thirdCategory.name_ru !== undefined) {
                        $("#category").append("&nbsp;/&nbsp;" + thirdCategory.name_ru);
                    }
                    else {
                        $("#category").append("&nbsp;/&nbsp;" + thirdCategory.name);
                    }
                }

                //var category = findJsonElementById(data, category);

                //if (category !== undefined) {
                //    if (category.name_ru !== undefined) {
                //        $("#category").html(category.name_ru);
                //    }
                //    else {
                //        $("#category").html(category.name);
                //    }
                //}

                //if (category.subcategories !== undefined) {
                //    $.each(category.subcategories, function (i, item) {
                //        $('#subCategories').append($('<option>', {
                //            value: item.id,
                //            text: item.name_ru
                //        }));
                //    });

                //    $("#subCategory").show();
                //}
                //else {
                //    $("#subCategory").hide();
                //}

            });
        });
    </script>

    <script>
        function setLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {

                    var innerHTMLgeo = "Latitude: " + position.coords.latitude + "<br>Longitude: " + position.coords.longitude;

                    document.getElementById("latgeo").value = position.coords.latitude;
                    document.getElementById("lnggeo").value = position.coords.longitude;

                    var latlng = position.coords.latitude + ',' + position.coords.longitude;

                    var googleUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + latlng + "&key=AIzaSyAEM6pBamtfcOxQiIHbO9HY76xvNiUxgIo";

                    var mapCenter = { lat: position.coords.latitude, lng: position.coords.longitude };

                    $.get(googleUrl, function (data) {

                        var firstResult = data.results[0];

                        $("#additem_place").val(firstResult.formatted_address);

                        var map = new google.maps.Map(document.getElementById('map'), { zoom: 17, center: mapCenter });
                        // The marker, positioned at Uluru
                        var marker = new google.maps.Marker({ position: mapCenter, map: map });
                    });
                },
                    function (error) {
                        // On error code..
                    },
                    { timeout: 30000, enableHighAccuracy: true, maximumAge: 75000 }
                );
            } else {
                x.innerHTML = "Geolocation is not supported by this browser.";
            }
        }

        function showError(error) {
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    x.innerHTML = "User denied the request for Geolocation."
                    break;
                case error.POSITION_UNAVAILABLE:
                    x.innerHTML = "Location information is unavailable."
                    break;
                case error.TIMEOUT:
                    x.innerHTML = "The request to get user location timed out."
                    break;
                case error.UNKNOWN_ERROR:
                    x.innerHTML = "An unknown error occurred."
                    break;
            }
        }
    </script>
    <script>
        var autocomplete;
        function initAutocomplete() {
            autocomplete = new google.maps.places.Autocomplete(
                document.getElementById('additem_place'), { types: ['geocode'] });

            autocomplete.setFields(['address_component']);

            autocomplete.addListener('place_changed', fillInAddress);
        }
        function fillInAddress() {
            var place = autocomplete.getPlace();
        }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAEM6pBamtfcOxQiIHbO9HY76xvNiUxgIo&libraries=places&callback=initAutocomplete"
        async defer></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-category">
            <div class="additem-left">
                <span>Категория</span>
            </div>
            <div class="additem-right additem__way" cid="<%=CategoryId %>">
                <a href="#" id="category">Category</a>
                <input type="hidden" id="category_hidden" value="<%=CategoryId %>" runat="server" />
            </div>
        </div>
        <div class="additem-category" id="subCategory" style="display: none;">
            <div class="additem-left">
                <span>Подкатегория</span>
            </div>
            <div class="additem-right additem__way" cid="">
                <select id="subCategories">
                </select>
                <input type="hidden" id="subcategory_hidden" value="" runat="server" />
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Название объявления</span>
            </div>
            <div class="additem-right additem__input-name">
                <input type="text" value="<%= Advert.Name %>" name="input_name" class="additem-input" required >
            </div>
        </div>

        <div class="additem-category additem-text__wrap">
            <div class="additem-left">
                <span class="additem-title">Описание объявления</span>
            </div>
            <div class="additem-right additem-input__text">
                <textarea type="textarea" name="input_text" class="additem-input additem-input__text" ><%= Advert.Description %></textarea>
            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Цена</span>
            </div>
            <div class="additem-right">
                <input type="number" value="<%= Advert.Price %>" name="price_value" class="additem-input additem__input-price" maxlength="14" required >
                <span class="price__value">₽</span>
                <div class="price__popup">
                    Какую цену указать
                                    <span class="price_arrow"></span>
                    <span class="price__open">Чтобы определиться с ценой, посмотрите, сколько за похожие товары просят конкуренты, учтите срок использования и имеющиеся дефекты.Если вы укажете слишком высокую цену или не обозначите её совсем, предложения конкурентов привлекут больше внимания. Неправдоподобно низкая цена может отпугнуть покупателя.
                    </span>
                </div>

            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Фотографии</span>
            </div>
            <div>
                
            </div>
            <div class="additem-right">
                <div id="mdropzone" class="dropzone"></div>
                <div id="my-dropzone" style="display: none;"></div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Видео с Youtube</span>
            </div>
            <div class="additem-right additem__video">
                <input type="text" value="<%= Advert.YouTubeUrl %>" name="input_video" class="additem-input additem__input-video" placeholder=" Например: https://www.youtube.com/watch?v=vMad0HvQ0k" >
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left additem-contact">
                Контактная информация
            </div>

        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Место сделки</span>
            </div>
            <div class="additem-right additem-place">
                <input type="text" value="<%= Advert.Address %>" name="additem_place" class="additem-input" required>
                <input type="hidden" id="latgeo" />
                <input type="hidden" id="lnggeo" />
                <input type="hidden" id="street_number_hidden" />
                <input type="hidden" id="route_hidden" />
                <input type="hidden" id="locality_hidden" />
                <input type="hidden" id="administrative_area_level_1_hidden" />
                <input type="hidden" id="country_hidden" />
                <input type="hidden" id="postal_code_hidden" />
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left ">
            </div>
            <div class="additem-right additem-map">
                <div class="additem-map">
                    <div id="map"></div>
                    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAEM6pBamtfcOxQiIHbO9HY76xvNiUxgIo&callback=initMap" async defer></script>
                </div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Телефон</span>
            </div>
            <div class="additem-right additem-phone">
                <input name="phonenum" value="<%= Advert.Phone %>" type="text" class="additem-input" placeholder="+7(___)___-__-__" required >
            </div>
        </div>
        <div class="additem-category additem-check__wrap">
            <div class="additem-left">
                <span class="additem-title">Способ связи</span>
            </div>
            <div class="additem-right">
                <div class="additem-checkbox">
                    <input type="radio" class="checkbox" id="phoneandmess" name="contact" checked >
                    <label class="checkbox-label" for="phoneandmess">
                        По телефону и в сообщениях
                    </label>
                </div>
                <div class="additem-checkbox">
                    <input type="radio" class="checkbox" id="onlyphone" name="contact" runat="server">
                    <label class="checkbox-label" for="onlyphone">
                        Только по телефону
                    </label>
                </div>
                <div class="additem-checkbox">
                    <input type="radio" class="checkbox" id="message" name="contact" runat="server">
                    <label class="checkbox-label" for="message">
                        Только в сообщениях
                    </label>
                </div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-right additem-go">
                <asp:Button ID="ButtonAddItem" runat="server" CssClass="additem-button" Text="Продолжить" OnClick="ButtonAddItem_Click" />
            </div>
        </div>
    </div>
</asp:Content>
