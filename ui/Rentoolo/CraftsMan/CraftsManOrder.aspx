<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManOrder.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .container {
            max-width: 960px;
        }

        .lh-condensed {
            line-height: 1.25;
        }

        .purple-border textarea {
            border: 1px solid #ba68c8;
        }

        .purple-border .form-control:focus {
            border: 1px solid #ba68c8;
            box-shadow: 0 0 0 0.2rem rgba(186, 104, 200, .25);
        }

        .green-border-focus .form-control:focus {
            border: 1px solid #8bc34a;
            box-shadow: 0 0 0 0.2rem rgba(139, 195, 74, .25);
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <body>

        <div class="py-5 text-center">
            <img class="d-block mx-auto mb-4" src="/assets/img/yellow-green.png" alt="" width="180" height="72">
            <h2>Оформление Заявки</h2>
            <p class="lead">Оставте заявку и мы найдем Вам специалиста, который справится с любым делом!</p>
        </div>

        <div class="col-md-10 order-md-1">
            <div class="form-group purple-border col-md-10">
                <label for="exampleFormControlTextarea4">В двух словах, что вам нужно?</label>
                <input type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
            </div>
            <div class="form-group purple-border col-md-10">
                <label for="exampleFormControlTextarea4">Опишите детали задачи</label>
                <textarea class="form-control" id="exampleFormControlTextarea4" rows="5"></textarea>
            </div>
            <div class="form-group purple-border col-md-10">
                <div class="additem-category">
                    <div class="additem-left">
                        <span class="additem-title">Добавить Фотографии</span>
                    </div>
                    <div class="additem-right">
                        <div id="mdropzone" class="dropzone"></div>
                        <div id="my-dropzone" style="display: none;"></div>
                    </div>
                </div>
            </div>
        </div>
        <form>
            <div class="form-group">
                <label for="customRange2">Установите приемлемую сумму оплаты</label>
                <input type="range" class="custom-range" min="0" max="500" id="customRange2">
            </div>
        </form>
        <div class="col-md-8 order-md-1">
            <h4 class="mb-3">Ваши контаткты</h4>
            <form class="needs-validation" novalidate>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="firstName">Фамилия</label>
                        <input type="text" class="form-control" id="firstName" placeholder="" value="" required>
                        <div class="invalid-feedback">
                            Valid first name is required.
           
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="lastName">Имя</label>
                        <input type="text" class="form-control" id="lastName" placeholder="" value="" required>
                        <div class="invalid-feedback">
                            Valid last name is required.
           
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="username">Username</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">@</span>
                        </div>
                        <input type="text" class="form-control" id="username" placeholder="Username" required>
                        <div class="invalid-feedback" style="width: 100%;">
                            Your username is required.
           
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="email">Email <span class="text-muted">(Optional)</span></label>
                    <input type="email" class="form-control" id="email" placeholder="you@example.com">
                    <div class="invalid-feedback">
                        Please enter a valid email address for shipping updates.
         
                    </div>
                </div>

                <div class="mb-3">
                    <label for="address">Адрес</label>
                    <input type="text" class="form-control" id="address" placeholder="1234 Main St" required>
                    <div class="invalid-feedback">
                        Please enter your shipping address.
         
                    </div>
                </div>
                <div class="mb-3">
                    <label for="phone">Телефон</label>
                    <input type="text" class="form-control" id="phone" placeholder="+7999-888-77-66" required>
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
                        <label for="state">Регион</label>
                        <select class="custom-select d-block w-100" id="state" required>
                            <option value="">Выбрать...</option>
                            <option>пример</option>
                        </select>
                        <div class="invalid-feedback">
                            Please provide a valid state.
           
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="zip">Zip</label>
                        <input type="text" class="form-control" id="zip" placeholder="" required>
                        <div class="invalid-feedback">
                            Zip code required.
           
                        </div>
                    </div>
                </div>
                <hr class="mb-4">
                <div class="custom-control custom-checkbox">
                    <input type="checkbox" class="custom-control-input" id="same-address">
                    <label class="custom-control-label" for="same-address">Shipping address is the same as my billing address</label>
                </div>
                <div class="custom-control custom-checkbox">
                    <input type="checkbox" class="custom-control-input" id="save-info">
                    <label class="custom-control-label" for="save-info">Save this information for next time</label>
                </div>
                <hr class="mb-4">

                <h4 class="mb-3">Payment</h4>

                <div class="d-block my-3">
                    <div class="custom-control custom-radio">
                        <input id="credit" name="paymentMethod" type="radio" class="custom-control-input" checked required>
                        <label class="custom-control-label" for="credit">Credit card</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input id="debit" name="paymentMethod" type="radio" class="custom-control-input" required>
                        <label class="custom-control-label" for="debit">Debit card</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input id="paypal" name="paymentMethod" type="radio" class="custom-control-input" required>
                        <label class="custom-control-label" for="paypal">PayPal</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="cc-name">Name on card</label>
                        <input type="text" class="form-control" id="cc-name" placeholder="" required>
                        <small class="text-muted">Full name as displayed on card</small>
                        <div class="invalid-feedback">
                            Name on card is required
           
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="cc-number">Credit card number</label>
                        <input type="text" class="form-control" id="cc-number" placeholder="" required>
                        <div class="invalid-feedback">
                            Credit card number is required
           
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label for="cc-expiration">Expiration</label>
                        <input type="text" class="form-control" id="cc-expiration" placeholder="" required>
                        <div class="invalid-feedback">
                            Expiration date required
           
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="cc-cvv">CVV</label>
                        <input type="text" class="form-control" id="cc-cvv" placeholder="" required>
                        <div class="invalid-feedback">
                            Security code required
           
                        </div>
                    </div>
                </div>
                <hr class="mb-4">
                <button class="btn btn-primary btn-lg btn-block" type="submit">Continue to checkout</button>
            </form>
        </div>
        <script src="/assets/js/jquery.min.js"></script>
        <script src="/assets/js/popper.min.js"></script>
        <script src="/assets/js/chart.js"></script>
        <script src="/assets/js/toolkit.js"></script>
        <script src="/assets/js/application.js"></script>
        <script>
            // execute/clear BS loaders for docs
            $(function () { while (window.BS && window.BS.loader && window.BS.loader.length) { (window.BS.loader.pop())() } })

                (function () {
                    'use strict'

                    window.addEventListener('load', function () {
                        // Fetch all the forms we want to apply custom Bootstrap validation styles to
                        var forms = document.getElementsByClassName('needs-validation')

                        // Loop over them and prevent submission
                        Array.prototype.filter.call(forms, function (form) {
                            form.addEventListener('submit', function (event) {
                                if (form.checkValidity() === false) {
                                    event.preventDefault()
                                    event.stopPropagation()
                                }
                                form.classList.add('was-validated')
                            }, false)
                        })
                    }, false)
                }())
        </script>

    </body>
</asp:Content>
