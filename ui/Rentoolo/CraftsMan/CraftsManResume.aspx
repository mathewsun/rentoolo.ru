<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManResume.aspx.cs" Inherits="Rentoolo.CraftsManResume" %>

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

     <div class="container-fluid">
        <div class="py-5 text-center">
            <img class="d-block mx-auto mb-4" src="/assets/img/yellow-green.png" alt="" width="180" height="72">
            <h2>Добавить Резюме</h2>
            <p class="lead">Оставте Своё резюме и вы найдете применение своим навыкам!</p>
        </div>

        <div class="container">
            <div class="row justify-content-md-center">
                <label for="input_nameTask">Укажите Вашу специальность</label>
                <input type="text" id="input_craft" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
            </div>
            <div class="row justify-content-md-center">
                <label for="input_description">Опишите Ваш опыт работы</label>
                <textarea class="form-control" id="input_description" rows="10"></textarea>
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
                <label for="price_value">Установите приемлемую сумму оплаты за Ваши услуги</label>
                <input type="range" class="custom-range" min="0" max="500" id="price_value">
            </div>
        </form>
        <div class="col-12 col-md-auto">

            <h4 class="mb-3">Ваши контаткты</h4>

            <form class="needs-validation" novalidate>
                <div class="row justify-content-md-center">
                    <div class="col-md-6 mb-3">
                        <label for="lastName">Фамилия</label>
                        <input type="text" class="form-control" id="input_lastName" placeholder="" value="" required>
                        <div class="invalid-feedback">
                            Valid first name is required.
           
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="firstName">Имя</label>
                        <input type="text" class="form-control" id="input_firstName" placeholder="" value="" required>
                        <div class="invalid-feedback">
                            Valid last name is required.
           
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
                    <input type="text" class="form-control" id="address" placeholder="пр.Мира,9/1a" required>
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
                <asp:Button runat="server" ID="addOrder" CssClass="additem-button" Text="Добавить" OnClick="ButtonResume_Click" />
        </div>
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


</asp:Content>
