<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddRent.aspx.cs" Inherits="Rentoolo.Account.AddRent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script src="/assets/js/dropzone/dropzone.js"></script>
    <link href="/assets/js/dropzone/dropzone.css" rel="stylesheet">
    <link href="/assets/js/dropzone/basic.css" rel="stylesheet">
    <script src="/assets/js/jsonUtils.js?2"></script>

    <script>
        $(document).ready(function () {
            $("#selector_minrenttime").change(function () {
                if ($("#selector_minrenttime").val() == "1") //День
                {
                    $("#PriceHour").hide();
                    $("#PriceMinute").hide();
                }
                else if ($("#selector_minrenttime").val() == "2") //Час
                {
                    $("#PriceMinute").hide();
                    $("#PriceHour").show();
                }
                else
                {
                    $("#PriceHour").show();
                    $("#PriceMinute").show();
                }
            });

            $("div#mdropzone").dropzone({
                url: "/api/upi",
                addRemoveLinks: true,
                acceptedFiles: ".jpeg,.jpg,.png,.gif",
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
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Название объявления</span>
            </div>
            <div class="additem-right additem__input-name">
                <input type="text" id="input_title" class="additem-input" required runat="server" />
            </div>
        </div>

        <div class="additem-category additem-text__wrap">
            <div class="additem-left">
                <span class="additem-title">Описание объявления</span>
            </div>
            <div class="additem-right additem-input__text">
                <textarea type="textarea" id="input_description" class="additem-input additem-input__text" runat="server"></textarea>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Минимальное время аренды</span>
            </div>
            <div class="additem-right">
                <select class="additem-input" id="input_minrenttime" required runat="server">
                    <option value="1">День</option>
                    <option value="2">Час</option>
                    <option value="3">Минута</option>
                </select>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Дата начала</span>
            </div>
            <div class="additem-right">
                <input class="additem-input" id="input_dateofstart" required runat="server" ClientIdMode="Static" type="date" name="dateEnd" />
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Дата окончания</span>
            </div>
            <div class="additem-right">
                <input class="additem-input" id="input_dateofend" required runat="server" ClientIdMode="Static" type="date" name="dateEnd" />
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Цена за 1 день</span>
            </div>
            <div class="additem-right">
                <input type="number" id="input_pricebyday" value="0" class="additem-input additem__input-price" maxlength="14" required runat="server">
                    <span class="price__value">₽</span>
                </input>
            </div>
        </div>

        <div class="additem-category" id="PriceHour" style="display: none">
            <div class="additem-left">
                <span class="additem-title">Цена за 1 час</span>
            </div>
            <div class="additem-right">
                <input type="number" id="input_pricebyhour" value="0" class="additem-input additem__input-price" maxlength="14" required runat="server">
                    <span class="price__value">₽</span>
                </input>
            </div>
        </div>

        <div class="additem-category" id="PriceMinute" style="display: none">
            <div class="additem-left">
                <span class="additem-title">Цена за 1 минуту</span>
            </div>
            <div class="additem-right">
                <input type="number" id="input_pricebyminute" value="0" class="additem-input additem__input-price" maxlength="14" required runat="server">
                    <span class="price__value">₽</span>
                </input>
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

        <div class="additem-category">
            <div class="additem-right additem-go">
                <asp:Button ID="ButtonAddItem" runat="server" CssClass="additem-button" Text="Продолжить" OnClick="ButtonAddItem_Click" />
            </div>
        </div>
    </div>
</asp:Content>
