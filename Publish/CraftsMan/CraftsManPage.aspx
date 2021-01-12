<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManPage.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <link href='assets/css.css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
    <link href="content/toolkit.css" rel="stylesheet">
    <link href="content/application.css" rel="stylesheet">

    <style>
        @media (min-width: 576px) {
            .card-columns {
                column-count: 2;
            }
        }

        @media (min-width: 768px) {
            .card-columns {
                column-count: 3;
            }
        }

        @media (min-width: 992px) {
            .card-columns {
                column-count: 4;
            }
        }

        @media (min-width: 1200px) {
            .card-columns {
                column-count: 5;
            }
        }
    </style>
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
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAEM6pBamtfcOxQiIHbO9HY76xvNiUxgIo&libraries=places&callback=initAutocomplete" async defer></script>
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

    <li class="media list-group-item p-4" style="margin-top: auto">

        <div class="search-input-group">

            <div class="search-input-group__main-input">
                <input style="width: 100%" type="text" id="Text1" class="form-control" runat="server" placeholder="Поиск по анкетам специалистов" />
                <asp:Button ID="Button1" runat="server" CssClass="btn btn-secondary align-self-stretch" Text="Найти" OnClick="ButtonSearch_Click" />
            </div>
            <div class="main-find__checkbox-label">
                <input type="checkbox" name="onlyInName" />
                <span>Только в названии</span>
            </div>

            <div class="main-find_price">
                <span>Стоимость услуг:</span>
                <input type="number" name="startPrice" placeholder="От" />
                <input type="number" name="endPrice" placeholder="До" />
            </div>
            <div class="city-sortby__wrap">
                <div>
                    <span style="float: left;">Город:</span>&nbsp;
                                        <input type="text" name="city" list="cities" />
                    <br />
                    <datalist id="cities">

                        <% foreach (var city in AllCities)
                            { %>

                        <option>
                            <%=city %>
                        </option>

                        <%} %>
                    </datalist>
                </div>
                <%-- citys end--%>

                <div class="sortby">
                    <select name="sortBy" id="sortBy">
                        <option value="date">По дате</option>
                        <option value="price">По стоимости услуг</option>
                        <option value="radius">По удаленности</option>
                    </select>
                </div>
                <%-- sortby end--%>
            </div>
            <%-- city-sortby__wrap end--%>
        </div>
        <%-- end search-input-group--%>
        <%--            <div class="input-group">
                                <div class="rowed-grid">
                                    <div class="searchbar-grid">
                                        <div style="width: 100%">
                                            <input style="width: 100%" type="text" id="InputSearch" class="form-control" runat="server" placeholder="Поиск по объявлениям" />
                                        </div>
                                        <div class="input-group-btn">
                                            <asp:Button ID="ButtonSearch" runat="server" CssClass="btn btn-secondary align-self-stretch" Text="Найти" OnClick="ButtonSearch_Click" />
                                        </div>
                                    </div>
                                    <div class="main-find__checkbox-label">
                                        <input type="checkbox" name="onlyInName" />
                                        <span>Только в названии</span>
                                    </div>
                                    <div>
                                        &nbsp;
                                        <br />
                                    </div>
                                 </div> 
                            </div> --%>
    </li>
    <h4 class="mb-4">Специалисты</h4>
    <div class="card-columns">
        <%foreach (var item in ListCraftsMan)
            {%>
        <div class="card">
            <div class="card-body">
                <a href="CraftsManProfile.aspx?id=<%= item.Id %>">
                    <div class="media-body-inline-grid" data-grid="images">
                        <div class="photoContainer" data='<%=item.ImgUrls%>'></div>
                    </div>
                    <h4 class="card-title"><%= item.Сraft %></h4>
                    <p class="card-text"><%= item.Description %></p>
                    <p class="card-text"><%= item.Id %></p>
                </a>

            </div>
        </div>
        <%} %>
    </div>

    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/chart.js"></script>
    <script src="js/toolkit.js"></script>
    <script src="js/application.js"></script>
    <script>
        // execute/clear BS loaders for docs
        $(function () { while (window.BS && window.BS.loader && window.BS.loader.length) { (window.BS.loader.pop())() } })
    </script>
</asp:Content>
