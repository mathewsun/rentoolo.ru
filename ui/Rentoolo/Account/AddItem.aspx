<%@ Page Title="Подать объявление" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddItem.aspx.cs" Inherits="Rentoolo.Account.AddItem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
            <div class="additem-right additem__way">
                <a href="#">Для бизнеса / Готовый бизнес / Другое</a>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Название объявления</span>
            </div>
            <div class="additem-right additem__input-name">
                <input type="text" class="additem-input" required>
            </div>
        </div>

        <div class="additem-category additem-text__wrap">
            <div class="additem-left">
                <span class="additem-title">Описание объявления</span>
            </div>
            <div class="additem-right additem-input__text">
                <textarea type="textarea" class="additem-input additem-input__text"></textarea>

            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Цена</span>
            </div>
            <div class="additem-right">
                <input type="number" class="additem-input additem__input-price" maxlength="14" required>
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
                <label for="file" class="label__file">
                    <img src="/assets/img/addphoto.svg" width="100px" alt="Добавить фотографию"></label>
                <input class="additem-input additem__input-photo" name="file" id="file" type="file" accept="image/gif,image/png,image/jpeg,image/pjpeg">
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Видео с Youtube</span>
            </div>
            <div class="additem-right additem__video">
                <input type="text" class="additem-input additem__input-video" placeholder=" Например: https://www.youtube.com/watch?v=vMad0HvQ0k">
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
                <input type="text" class="additem-input" required>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left ">
            </div>
            <div class="additem-right additem-map">
                <iframe src="https://yandex.ru/map-widget/v1/?um=constructor%3A877125111ad65104c6d5637b07b64b6a62ee325e975f67a8df120a2740017f7e&amp;source=constructor" width="500" height="208" frameborder="0.6px"></iframe>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Телефон</span>
            </div>
            <div class="additem-right additem-phone">
                <input id="phonenum" type="text" class="additem-input" placeholder="+7(___)___-__-__" required>
            </div>
        </div>
        <div class="additem-category additem-check__wrap">
            <div class="additem-left">
                <span class="additem-title">Способ связи</span>
            </div>
            <div class="additem-right">
                <div class="additem-checkbox">
                    <input type="radio" class="checkbox" id="phoneandmess" name="contact" checked>
                    <label class="checkbox-label" for="phoneandmess">
                        По телефону и в сообщениях
                    </label>
                </div>
                <div class="additem-checkbox">
                    <input type="radio" class="checkbox" id="onlyphone" name="contact">
                    <label class="checkbox-label" for="onlyphone">
                        Только по телефону
                    </label>
                </div>
                <div class="additem-checkbox">
                    <input type="radio" class="checkbox" id="message" name="contact">
                    <label class="checkbox-label" for="message">
                        Только в сообщениях
                    </label>
                </div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-right additem-go">
                <button type="#" class="additem-button">Продолжить</button>
            </div>
        </div>


    </div>
</asp:Content>
