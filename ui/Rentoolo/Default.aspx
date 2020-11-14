<%@ Page Title="Rentoolo" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Rentoolo._Default" EnableEventValidation="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="rentoolo">
    <meta name="keywords" content="rentoolo">
    <meta name="author" content="rentoolo">
    <link rel="shortcut icon" href="/assets/img/yellow-green.ico">

    <title>Rentoolo - Ваши объявления</title>

    <meta property="og:title" content="Rentoolo - Ваши объявления" />
    <meta property="mrc__share_title" content="Rentoolo - Ваши объявления" />
    <meta property="twitter:title" content="Rentoolo - Ваши объявления" />
    <meta property="vk:image" content="https://www.Rentoolo.ru/assets/img/banner_1.jpg" />
    <meta property="og:image" content="https://www.Rentoolo.ru/assets/img/banner_1.jpg" />
    <meta property="twitter:image" content="https://www.Rentoolo.ru/assets/img/banner_1.jpg" />
    <meta property="image" content="https://www.Rentoolo.ru/assets/img/banner_1.jpg" />

    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
    <link href="assets/css/toolkit.css?422" rel="stylesheet">
    <link href="assets/css/application.css?244" rel="stylesheet">
    <link href="assets/css/additional.css?88822" rel="stylesheet">

    <meta name="yandex-verification" content="f9c03f80c16c0af8" />
    <meta name="google-site-verification" content="BfIjGZxsZYqrNnWTzlNb6Whynn4y6hOC5amjYpEcDLk" />

    <link href="assets/css/jQuery.Brazzers-Carousel.css?22" rel="stylesheet">

    <style>
        /* note: this is a hack for ios iframe for bootstrap themes shopify page */
        /* this chunk of css is not part of the toolkit :) */
        body {
            width: 1px;
            min-width: 100%;
            *width: 100%;
        }


        .searchbar-grid {
            width: 100%;
            display: grid;
            grid-template-columns: 80% 20%;
        }


        .rowed-grid {
            width: 100%;
            display: grid;
            grid-template-columns: 1fr;
            grid-row-gap: 5px;
        }

        .margin-block {
            margin-bottom: 5px;
            margin-top: 5px;
        }
    </style>

    <script src="/assets/js/jquery-2.2.4.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
    <script src="/assets/js/utils.js?1"></script>
    <script src="/assets/js/jQuery.Brazzers-Carousel.js"></script>


    <script>
        $(document).ready(function () {

            // Size of browser viewport.
            var height1 = $(window).height();
            var width1 = $(window).width();

            // Size of HTML document (same as pageHeight/pageWidth in screenshot).
            var height2 = $(document).height();
            var width2 = $(document).width();

            // Screen size
            var height3 = window.screen.height;
            var width3 = window.screen.width;

            $("#allCategorieslist").click(function () {
                if ($(".more-popup").is(":visible")) {
                    $(".more-popup").fadeOut(300);

                } else {
                    $(".more-popup").fadeIn(300);
                };
            });

            $(".item-wrap__like").click(function () {
                $(this).toggleClass('item-wrap__like-active');
            });

            $(".photoContainer").each(function (index) {
                var htmlString = '';
                var imgUrls = $(this).attr("data");
                JSON.parse(imgUrls,
                    function (k, v) {
                        if (k != "") {
                            htmlString += "<img src='" + v + "' style='height: 120px; width: 170px;' class='advert-img' alt='' />";
                        }
                    });

                $(this).html(htmlString);
            });

            $(".photoContainer").brazzersCarousel();

            if (width1 < 512 || width2 < 512 || width3 < 512) {
                $(".href-photoContainer").attr("href", "#");
            }

            $(".item-wrap__description-description").each(function (index) {
                var innerHtml = $(this).html();
                var length = 70;
                var trimmedHtml = innerHtml.length > length ?
                    innerHtml.substring(0, length - 3) + "..." :
                    innerHtml;
                $(this).html(trimmedHtml);
            });

            selectElementSortBy();
        });

        $(window).resize(function () {
            // Size of browser viewport.
            var height1 = $(window).height();
            var width1 = $(window).width();

            // Size of HTML document (same as pageHeight/pageWidth in screenshot).
            var height2 = $(document).height();
            var width2 = $(document).width();

            // Screen size
            var height3 = window.screen.height;
            var width3 = window.screen.width;

            if (width1 < 512 || width2 < 512 || width3 < 512) {
                $(".href-photoContainer").attr("href", "#");
            }
        });

        function selectElementSortBy() {

            var url_string = window.location.href;
            var url = new URL(url_string);
            var s = url.searchParams.get("sort");

            if (s == null) { s = "date";}
            let element = document.getElementById("sortBy");
            element.value = s;
        }
    </script>

    <!-- Yandex.Metrika counter -->
    <script type="text/javascript">
        (function (m, e, t, r, i, k, a) {
            m[i] = m[i] || function () { (m[i].a = m[i].a || []).push(arguments) };
            m[i].l = 1 * new Date(); k = e.createElement(t), a = e.getElementsByTagName(t)[0], k.async = 1, k.src = r, a.parentNode.insertBefore(k, a)
        })
            (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

        ym(55995166, "init", {
            clickmap: true,
            trackLinks: true,
            accurateTrackBounce: true
        });
    </script>
    <noscript>
        <div>
            <img src="https://mc.yandex.ru/watch/55995166" style="position: absolute; left: -9999px;" alt="" />
        </div>
    </noscript>
    <!-- /Yandex.Metrika counter -->

</head>


<body class="with-top-navbar">
    <form runat="server">
        <div class="growl" id="app-growl"></div>

        <nav class="navbar navbar-expand-md fixed-top navbar-dark bg-primary app-navbar">

            <a class="navbar-brand" href="/">
                <span class="logo-text" style="margin-right: -3px;">Rent</span>
                <img class="logo-img" src="assets/img/yellow-green.png" alt="brand">
                <span class="logo-text" style="margin-left: -3px;">lo</span>
            </a>

            <div class="d-md-none">
                <a class="nav-link add-advert-header-icon" title="Подать объявление" href="/Account/Category">
                    <div class="icon icon-add-advert"></div>
                </a>
                <a class="nav-link favorites-header-icon" title="Избранное" href="/Favorites.aspx">
                    <div class="icon icon-favorite"></div>
                </a>
                <button
                    class="navbar-toggler navbar-toggler-right "
                    type="button"
                    data-toggle="collapse"
                    data-target="#navbarResponsive"
                    aria-controls="navbarResponsive"
                    aria-expanded="false"
                    aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>

            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="/">Купить/Продать</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/Rent">Аренда</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/Auctions">Аукционы</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/Tenders.aspx">Тендеры</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">Магазины</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">Работа</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">Услуги</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/Tokens">Токены</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/Account/Cabinet">Кабинет</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/News">Новости</a>
                    </li>
                    <asp:LoginView ID="LoginView1" runat="server" ViewStateMode="Disabled">
                        <AnonymousTemplate>
                            <li class="nav-item d-md-none">
                                <a class="nav-link" href="/Account/Login">Вход и регистрация</a>
                            </li>
                            </ul>
                        <ul id="#js-popoverContent" class="nav navbar-nav float-right mr-0 d-none d-md-flex">
                            <li class="nav-item">
                                <a class="nav-link" href="/Favorites">
                                    <div class="favorite-top" title="Избранное"></div>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a id="loginLink" runat="server" class="nav-link login" href="~/Account/Login">Вход и регистрация</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/Account/Category">
                                    <span class="btn btn-sm btn-pill btn-primary">Подать объявление</span>
                                </a>
                            </li>
                        </ul>
                        </AnonymousTemplate>
                        <LoggedInTemplate>
                            <li class="nav-item d-md-none">
                                <asp:LoginStatus ID="LoginStatus3" CssClass="nav-link" runat="server" LogoutAction="Redirect" OnLoggedOut="LoginStatus1_LoggedOut" LogoutText="Выйти" LogoutPageUrl="~/" />
                            </li>
                            </ul>
                            <ul id="#js-popoverContent" class="nav navbar-nav float-right mr-0 d-none d-md-flex">
                                <% if (Page.User.IsInRole("Administrator"))
                                    { %>
                                <li><a id="A1" runat="server" href="~/Admin/Admin.aspx">
                                    <img class="setting-img" src="assets/img/settings-icon-50.png" title="Управление" /></a></li>
                                <% } %>

                                <li class="nav-item">
                                    <a class="nav-link" title="Избранное" href="/Favorites">
                                        <div class="icon icon-favorite"></div>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="/Account/Category">
                                        <span class="btn btn-sm btn-pill btn-primary">Подать объявление</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="app-notifications nav-link" href="/">
                                        <span class="icon icon-bell"></span>
                                    </a>
                                </li>
                                <li class="nav-item ml-2">
                                    <div class="btn btn-default navbar-btn navbar-btn-avatar" data-toggle="popover">
                                        <img class="rounded-circle" src="assets/img/avatar-dhg.png">
                                    </div>
                                </li>
                            </ul>

                            <ul class="nav navbar-nav d-none" id="js-popoverContent">
                                <li class="nav-item"><a class="nav-link blue-color" href="/Account/MyAdverts.aspx">My Adverts</a></li>
                                <li class="nav-item"><a id="A2" runat="server" class="nav-link blue-color username" href="~/Account/Cabinet.aspx" title="Личный кабинет">Кабинет</a></li>
                                <li class="nav-item">
                                    <asp:LoginStatus CssClass="nav-link blue-color" ID="LoginStatus2" runat="server" LogoutAction="Redirect" OnLoggedOut="LoginStatus1_LoggedOut" LogoutText="Выйти" LogoutPageUrl="~/" />
                                </li>
                            </ul>

                            <ul class="nav navbar-nav d-none">
                                <li><a id="CabinetLink" runat="server" class="username" href="~/Account/Cabinet.aspx" title="Личный кабинет">Кабинет (<asp:LoginName ID="LoginName1" runat="server" CssClass="username" />
                                    )
                                </a></li>
                                <li>
                                    <asp:LoginStatus ID="LoginStatus1" runat="server" LogoutAction="Redirect" OnLoggedOut="LoginStatus1_LoggedOut" LogoutText="Выйти" LogoutPageUrl="~/" />
                                </li>
                            </ul>
                        </LoggedInTemplate>
                    </asp:LoginView>
            </div>
        </nav>

        <div class="modal fade" id="userModal" tabindex="-1" role="dialog" aria-labelledby="userModal" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Users</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>

                    <div class="modal-body p-0">
                        <div class="modal-body-scroller">
                            <ul class="media-list media-list-users list-group">
                                <li class="list-group-item">
                                    <div class="media w-100">
                                        <img class="media-object d-flex align-self-start mr-3" src="assets/img/avatar-fat.jpg">
                                        <div class="media-body">
                                            <button class="btn btn-secondary btn-sm float-right">
                                                <span class="glyphicon glyphicon-user"></span>Follow
                 
                                            </button>
                                            <strong>Майк Браун</strong>
                                            <p>@fat - San Francisco</p>
                                        </div>
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="media w-100">
                                        <img class="media-object d-flex align-self-start mr-3" src="assets/img/avatar-dhg.png">
                                        <div class="media-body">
                                            <button class="btn btn-secondary btn-sm float-right">
                                                <span class="glyphicon glyphicon-user"></span>Follow
                 
                                            </button>
                                            <strong>Dave Gamache</strong>
                                            <p>@dhg - Palo Alto</p>
                                        </div>
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="media w-100">
                                        <img class="media-object d-flex align-self-start mr-3" src="assets/img/avatar-mdo.png">
                                        <div class="media-body">
                                            <button class="btn btn-secondary btn-sm float-right">
                                                <span class="glyphicon glyphicon-user"></span>Follow
                 
                                            </button>
                                            <strong>Виктория Золотова</strong>
                                            <p>@mdo - San Francisco</p>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container pt-4 pb-5">
            <div class="row">
                <div class="col-lg-9">

                    <ul class="list-group media-list media-list-stream mb-4">

                        <li class="media list-group-item p-4 li-header-categories-group">
                            <div class="header-categories-group">
                                <ul class="ul-header-categories">
                                    <li>
                                        <a class="link-header-categories" href="/">Авто</a>
                                    </li>
                                    <li>
                                        <a class="link-header-categories" href="/">Недвижимость</a>
                                    </li>
                                    <li>
                                        <a class="link-header-categories" href="/">Хобби и отдых</a>
                                    </li>
                                    <li>
                                        <a class="link-header-categories" href="/">Личные вещи</a>
                                    </li>
                                    <li>
                                        <a class="link-header-categories" href="/Business.aspx">Бизнес</a>
                                    </li>
                                    <li>
                                        <span id="allCategorieslist" class="link-header-categories more-link">еще..</span>
                                    </li>
                                </ul>
                                <div class="more-popup">
                                    <div class="more-popup__arrow">
                                    </div>
                                    <div class="popup__wrapper">
                                        <div class="popup__title">
                                            <a href="#">Все категории</a>
                                        </div>
                                        <div class="popup__wrap">
                                            <div class="popup__column">
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Транспорт</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Автомобили</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Мотоциклы и мототехника</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Грузовики и спецтехника</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Водный транспорт</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Запчасти и аксессуары</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Для дома и дачи</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Бытовая техника</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Мебель и интерьер</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Посуда и товары для кухни</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Продукты питания</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Ремонт и строительство</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Растения</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Для бизнеса</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Готовый бизнес</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Оборудование для бизнеса</a></li>
                                                </ul>
                                            </div>
                                            <div class="popup__column">
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Недвижимость</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Квартиры</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Комнаты</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Дома, дачи, коттеджи</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Земельные участки</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Гаражи и машиноместа</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Коммерческая недвижимость</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Недвижимость за рубежом</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Бытовая электроника</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Аудио и видео</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Игры, приставки и программы</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Настольные компьютеры</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Ноутбуки</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Оргтехника и расходники</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Планшеты и электронные книги</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Телефоны</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Товары для компьютера</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Фототехника</a></li>
                                                </ul>
                                            </div>
                                            <div class="popup__column">
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Работа</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Вакансии</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Резюме</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Услуги</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Хобби и отдых</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Билеты и путешествия</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Велосипеды</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Книги и журналы</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Коллекционирование</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Музыкальные инструменты</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Охота и рыбалка</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Спорт и отдых</a></li>
                                                </ul>
                                            </div>
                                            <div class="popup__column">
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="/Account/AddItem.aspx">Личные вещи</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Одежда, обувь, аксессуары</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Детская одежда и обувь</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Товары для детей и игрушки</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Часы и украшения</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Красота и здоровье</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Животные</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Собаки</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Кошки</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Птицы</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Аквариум</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Другие животные</a></li>
                                                    <li><a href="/Account/AddItem.aspx">Товары для животных</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>

                        <li class="media list-group-item p-4">

                            <div class="search-input-group">

                                <div class="search-input-group__main-input">
                                    <input style="width: 100%" type="text" id="Text1" class="form-control" runat="server" placeholder="Поиск по объявлениям" />
                                    <asp:Button ID="Button1" runat="server" CssClass="btn btn-secondary align-self-stretch" Text="Найти" OnClick="ButtonSearch_Click" />
                                </div>
                                <div class="main-find__checkbox-label">
                                    <input type="checkbox" name="onlyInName" />
                                    <span>Только в названии</span>
                                </div>

                                <div class="main-find_price">
                                    <span>Цена:</span>
                                    <input type="number" name="startPrice" placeholder="От" />
                                    <input type="number" name="endPrice" placeholder="До" />
                                </div>


                                <%--                           <div class="main-find_date">
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
                                            <option value="price">По цене</option>
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

                        <li class="media list-group-item p-4">

                            <div class="media-body">
                                <div class="media-heading">
                                    <small class="float-right text-muted"><%=AdvertsCount %> объявлений</small>
                                    <h6>Бытовая электроника:</h6>
                                </div>

                                <div class="media-body-inline-grid" data-grid="images">
                                    <%foreach (var item in ListAdverts)
                                        { %>
                                    <div class="item-wrap" style="display: none" aid="<%=item.Id%>">
                                        <a href="Advert.aspx?id=<%=item.Id%>" class="href-photoContainer" title="<%=item.Name%>">
                                            <div class="photoContainer" data='<%=item.ImgUrls%>'></div>
                                        </a>
                                        <div class="item-wrap__wrap ">
                                            <div class="item-wrap__name"><a href="Advert.aspx?id=<%=item.Id%>"><%=item.Name%></a></div>
                                            <div class="item-wrap__cost"><%=item.Price%> ₽<%--<%=item.CurrencyAcronim%>--%></div>
                                            <div class="item-wrap__description">
                                                <p><span class="item-wrap__description-description" maxlength="20"><%=item.Description%></span></p>
                                                <p><%=item.Category%></p>
                                                <p><%=item.Address%></p>
                                                <div class="item-wrap__data"><%=item.Created.ToString("dd.MM.yyyy HH:mm")%></div>
                                            </div>
                                        </div>
                                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                                    </div>
                                    <%} %>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="col-lg-3">
                    <div class="card mb-4 d-none d-lg-block">
                        <div class="card-body">
                            <h6 class="mb-3">Вы смотрели: <small>· <a href="/Account/Watched.aspx">Показать все</a></small></h6>
                            <div data-grid="images" data-target-height="150">
                                <img class="media-object" data-width="640" data-height="640" data-action="zoom" src="assets/img/instagram_2.jpg">
                            </div>
                            <p><strong>Ноутбук Acer Predator Heliios-300.</strong> Iceland is so chill, and everything looks cool here. Also, we heard the people are pretty nice. What are you waiting for?</p>
                        </div>
                    </div>
                    <div class="card mb-4 d-none d-lg-block">
                        <div class="card-body">
                            <h6 class="mb-3">Ваши объявления: <small>· <a href="/Account/MyAdverts.aspx">Показать все</a></small></h6>
                            <div data-grid="images" data-target-height="150">
                                <img class="media-object" data-width="640" data-height="640" data-action="zoom" src="assets/img/varianty-planirovki-3-h-komnatnoj-kvartiry-v-hrushchevke-7.jpg">
                            </div>
                            <p><strong>3х комнатная квартира СЗАО Москва</strong> Iceland is so chill, and everything looks cool here. Also, we heard the people are pretty nice. What are you waiting for?</p>
                        </div>
                    </div>
                    <div class="card mb-4 d-none d-lg-block">
                        <div class="card-body">
                            <h6 class="mb-3">Избранное: <small>· <a href="/Favorites.aspx">Показать все</a></small></h6>
                            <div data-grid="images" data-target-height="150">
                                <img class="media-object" data-width="640" data-height="640" data-action="zoom" src="assets/img/kurier-piter.jpg">
                            </div>
                            <p><strong>Курьер. Курьерские услуги. Санкт-Петербург.</strong> Iceland is so chill, and everything looks cool here. Also, we heard the people are pretty nice. What are you waiting for?</p>
                        </div>
                    </div>

                    <div class="card card-link-list">
                        <div class="card-body">
                            © Rentoolo
                            <a href="https://github.com/mathewsun/rentoolo.ru">GitHub</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/chart.js"></script>
        <script src="assets/js/toolkit.js?2"></script>
        <script src="assets/js/application.js"></script>
        <script>
            // execute/clear BS loaders for docs
            $(function () { while (window.BS && window.BS.loader && window.BS.loader.length) { (window.BS.loader.pop())() } })
        </script>
    </form>
</body>
</html>

