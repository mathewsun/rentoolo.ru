<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManOrder.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
                    $("#my-dropzone").append($('<input type="hidden" name="OrderPhotos" ' + 'value="' + filaName + '">'));
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-category">
            <h2>Оформление Заявки</h2>
        </div>
        <hr class="mb-4">
        <div class="additem-right">
            <div class="additem-category additem-text__wrap">
                <label for="input_nameTask">В двух словах, что вам нужно?</label>
                <input type="text" id="input_nameTask" name="input_nameTask" runat="server" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
            </div>
            <hr class="mb-4">
            <div class="additem-category additem-text__wrap">
                <label for="input_description">Опишите детали задачи</label>
                <textarea class="form-control" id="input_description" runat="server" rows="5"></textarea>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Укажите приемлемую цену услуг</span>
            </div>
            <div class="additem-right">
                <input type="number" id="input_price" class="additem-input additem__input-price" maxlength="14" required runat="server">
                <span class="price__value">₽</span>
                <div class="price__popup">
                    Какую цену указать
                                    <span class="price_arrow"></span>
                    <span class="price__open">Чтобы определиться с ценой, посмотрите, сколько за похожие товары просят конкуренты, учтите срок использования и имеющиеся дефекты.Если вы укажете слишком высокую цену или не обозначите её совсем, предложения конкурентов привлекут больше внимания. Неправдоподобно низкая цена может отпугнуть покупателя. </span>
                </div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Добавте Фотографии</span>
            </div>
            <div class="additem-right">
                <div id="mdropzone" class="dropzone"></div>
                <div id="my-dropzone" style="display: none;"></div>
            </div>
        </div>
        <h4 class="mb-3">Ваши контаткты</h4>
        <div class="row justify-content-md-center">
            <div class="col-md-6 mb-3">
                <label for="lastName">Фамилия</label>
                <input type="text" class="form-control" runat="server" id="input_lastName" placeholder="" value="" required>
                <div class="invalid-feedback">
                    Valid first name is required.
           
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="firstName">Имя</label>
                <input type="text" class="form-control" runat="server" id="input_firstName" placeholder="" value="" required>
                <div class="invalid-feedback">
                    Valid last name is required.
           
                </div>
            </div>
        </div>
        <div class="mb-3">
            <label for="email">Email <span class="text-muted">(Optional)</span></label>
            <input type="email" class="form-control" runat="server" id="email" placeholder="you@example.com">
            <div class="invalid-feedback">
                Please enter a valid email address for shipping updates.
         
            </div>
        </div>

        <div class="mb-3">
            <label for="address">Адрес</label>
            <input type="text" class="form-control" runat="server" id="address" placeholder="пр.Мира,9/1a" required>
            <div class="invalid-feedback">
                Please enter your shipping address.
         
            </div>
        </div>
        <div class="mb-3">
            <label for="phone">Телефон</label>
            <input type="text" class="form-control" runat="server" id="phone" placeholder="+7999-888-77-66" required>
            <div class="invalid-feedback">
                Please enter your phone.
         
            </div>
        </div>
        <div class="row">
            <div class="col-md-5 mb-3">
                <label for="country">Страна</label>
                <select class="custom-select d-block w-100" id="country" required>
                    <option value="">Choose...</option>
                    <option>United States</option>
                </select>
                <div class="invalid-feedback">
                    Please select a valid country.
           
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <label for="region">Регион</label>
                <select class="custom-select d-block w-100" id="region" required>
                    <option value="">Выбрать...</option>
                    <option>пример</option>
                </select>
                <div class="invalid-feedback">
                    Please provide a valid state.
           
                </div>
            </div>
        </div>
        <hr class="mb-4">
        <asp:Button ID="addOrder" runat="server" CssClass="additem-button" Text="Добавить" OnClick="ButtonOrder_Click" />
    </div>
</asp:Content>
