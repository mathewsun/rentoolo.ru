<%@ Page Title="Подать объявление" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddItem.aspx.cs" Inherits="Rentoolo.Account.AddItem" %>

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

    <script>
        $(document).ready(function () {
            $("div#mdropzone").dropzone({
                url: "/api/upi",
                addRemoveLinks: true
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-logo">
            <h4>Подать обьявление</h4>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span>Категория</span>
            </div>
            <div class="additem-right additem__way" cid="1001">
                <a href="#">Для бизнеса / Готовый бизнес / Другое</a>
                <input type="hidden" id="category_hidden" value="1001" runat="server" />
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Название объявления</span>
            </div>
            <div class="additem-right additem__input-name">
                <input type="text" id="input_name" class="additem-input" required runat="server">
            </div>
        </div>

        <div class="additem-category additem-text__wrap">
            <div class="additem-left">
                <span class="additem-title">Описание объявления</span>
            </div>
            <div class="additem-right additem-input__text">
                <textarea type="textarea" id="input_text" class="additem-input additem-input__text" runat="server"></textarea>
            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Цена</span>
            </div>
            <div class="additem-right">
                <input type="number" id="price_value" class="additem-input additem__input-price" maxlength="14" required runat="server">
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
            <div class="additem-right">
                <div id="mdropzone" class="dropzone"></div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Видео с Youtube</span>
            </div>
            <div class="additem-right additem__video">
                <input type="text" id="input_video" class="additem-input additem__input-video" placeholder=" Например: https://www.youtube.com/watch?v=vMad0HvQ0k" runat="server">
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
                <input type="text" id="additem_place" class="additem-input" required runat="server">
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
                <input id="phonenum" type="text" class="additem-input" placeholder="+7(___)___-__-__" required runat="server">
            </div>
        </div>
        <div class="additem-category additem-check__wrap">
            <div class="additem-left">
                <span class="additem-title">Способ связи</span>
            </div>
            <div class="additem-right">
                <div class="additem-checkbox">
                    <input type="radio" class="checkbox" id="phoneandmess" name="contact" checked runat="server">
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
