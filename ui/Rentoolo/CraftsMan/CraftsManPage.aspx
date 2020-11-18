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

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <!-- Button trigger modal -->
    <button type="button" class="btn btn-outline-primary" data-toggle="modal" data-target="#exampleModal">
        Оформление Заявки
    </button>
    <%--<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">
        Добавь свое резюме
    </button>--%>

    <!-- Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Оформление Заявки</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="py-5 text-center">
                        <img class="d-block mx-auto mb-4" src="/assets/img/yellow-green.png" alt="" width="180" height="72">
                        <h2>Оформление Заявки</h2>
                        <p class="lead">Оставте заявку и мы найдем Вам специалиста, который справится с любым делом!</p>
                    </div>

                    <div class="col-md-10 order-md-1">
                        <div class="form-group purple-border col-md-10">
                            <label for="input_nameTask">В двух словах, что вам нужно?</label>
                            <input type="text" id="input_nameTask"  class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
                        </div>
                        <div class="form-group purple-border col-md-10">
                            <label for="input_description">Опишите детали задачи</label>
                            <textarea class="form-control" id="input_description" rows="5"></textarea>
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
                            <label for="price_value">Установите приемлемую сумму оплаты</label>
                            <input type="range" class="custom-range" min="0" max="500" id="price_value">
                        </div>
                    </form>
                    <div class="col-md-8 order-md-1">
                        <h4 class="mb-3">Ваши контаткты</h4>
                        <form class="needs-validation" novalidate>
                            <div class="row">
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
                       
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                    <asp:Button ID="AddOrder" runat="server" CssClass="additem-button" Text="Добавить" OnClick="ButtonOrder_Click" />
                </div>
            </div>
        </div>
    </div>
    <li class="media list-group-item p-4">

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


            <%--<div class="main-find_date">
                 <span>Дата размещения:</span> 
                 <input type="date" id="StartDate" placeholder="От">
                 <input type="date" id="EndDate" placeholder="До">
                                    </div>
         51a73fc4667aa3e6c7e3a45ccc1c5b82545a2ee0 --%>


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
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">1 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">2 Card title</h4>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">3 Card title</h4>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">4 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">5 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">6 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">7 Card title</h4>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">8 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">9. Card title</h4>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <img class="card-img-top" src="../assets/img/instagram_10.jpg" alt="Card image">
                <h4 class="card-title">10 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
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

    <script>
        $('#myModal').on('shown.bs.modal', function () {
            $('#myInput').trigger('focus')
        })
    </script>

</asp:Content>
