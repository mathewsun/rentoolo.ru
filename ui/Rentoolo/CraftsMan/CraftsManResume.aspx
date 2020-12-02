<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManResume.aspx.cs" Inherits="Rentoolo.CraftsManResume" %>

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
                    var filaName = response.Message;
                    file.previewElement.classList.add("dz-success");
                    $("#my-dropzone").append($('<input type="hidden" name="ResumePhotos" ' + 'value="' + filaName + '">'));
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-category">
            <h2>Добавить Резюме</h2>
        </div>
        <hr class="mb-4">
        <div class="additem-right">
            <div class="additem-category additem-text__wrap">
                <label for="input_craft">Укажите Вашу специальность</label>
                <input type="text" id="input_craft" name="input_craft" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg"">
            </div>
            <hr class="mb-4">
            <div class="additem-category additem-text__wrap">
                <label for="input_description" runat="server">Опишите Ваш опыт работы</label>
                <textarea class="form-control" id="input_description" name="input_description"  rows="10"></textarea>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Укажите приемлемую цену за Ваши услуги</span>
            </div>
            <div class="additem-right">
                <input type="number" id="input_price" name="input_price" class="additem-input additem__input-price"  required >
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
                <div id="my-dropzone" style="display: none;"></div>
            </div>
        </div>
        <h4 class="mb-3">Ваши контаткты</h4>
        <div class="row justify-content-md-center">
            <div class="col-md-6 mb-3">
                <label for="lastName">Фамилия</label>
                <input type="text" class="form-control" id="input_lastName" name="input_lastName"  placeholder="" value="" required>
                <div class="invalid-feedback">
                    Valid first name is required.
           
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="firstName">Имя</label>
                <input type="text" class="form-control" id="input_firstName" name="input_firstName"  placeholder="" value="" required>
                <div class="invalid-feedback">
                    Valid last name is required.
           
                </div>
            </div>
        </div>
        <div class="mb-3">
            <label for="email">Email <span class="text-muted">(Optional)</span></label>
            <input type="email" class="form-control" id="email" name="email" placeholder="you@example.com">
            <div class="invalid-feedback">
                Please enter a valid email address for shipping updates.
         
            </div>
        </div>
        <div class="mb-3">
            <label for="address">Адрес</label>
            <input type="text" class="form-control"  id="address" name="address" placeholder="пр.Мира,9/1a" required>
            <div class="invalid-feedback">
                Please enter your shipping address.
         
            </div>
        </div>
        <div class="mb-3">
            <label for="phone">Телефон</label>
            <input type="text" class="form-control" id="phone" name="phone"  placeholder="+7999-888-77-66" required>
            <div class="invalid-feedback">
                Please enter your phone.
         
            </div>
        </div>
  <div class="row">
            <div class="col-md-4 mb-3">

                <span style="float: left;">Город:</span>&nbsp;
                                        <input type="text"  class="form-control" name="city" list="cities" />
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
                        <input type="radio" class="checkbox" id="onlyphone" name="contact" >
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
         </div>
        <div class="additem-category">
            <div class="additem-right additem-go">
                <asp:Button runat="server" ID="addOrder" CssClass="additem-button" Text="Добавить" OnClick="ButtonResume_Click" />
            </div>
        </div>
   
</asp:Content>
