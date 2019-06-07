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

    <title>Rentoolo - Ваши объявления
      
    </title>

    <meta property="og:title" content="Rentoolo - Ваши объявления" />
    <meta property="mrc__share_title" content="Rentoolo - Ваши объявления" />
    <meta property="twitter:title" content="Rentoolo - Ваши объявления" />
    <meta property="vk:image" content="http://www.Rentoolo.ru/assets/img/banner_1.jpg" />
    <meta property="og:image" content="http://www.Rentoolo.ru/assets/img/banner_1.jpg" />
    <meta property="twitter:image" content="http://www.Rentoolo.ru/assets/img/banner_1.jpg" />
    <meta property="image" content="http://www.Rentoolo.ru/assets/img/banner_1.jpg" />

    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
    <link href="assets/css/toolkit.css" rel="stylesheet">
    <link href="assets/css/application.css" rel="stylesheet">
    <link href="assets/css/additional.css?2" rel="stylesheet">

    <style>
        /* note: this is a hack for ios iframe for bootstrap themes shopify page */
        /* this chunk of css is not part of the toolkit :) */
        body {
            width: 1px;
            min-width: 100%;
            *width: 100%;
        }
    </style>

    <script src="/assets/js/jquery-2.2.4.js"></script>

    <script>
        $(document).ready(function () {
            $("#allCategorieslist").click(function () {
                if ($(".more-popup").is(":visible")) {
                    $(".more-popup").fadeOut(300);

                } else {
                    $(".more-popup").fadeIn(300);
                };
            });
        });
    </script>

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

            <button
                class="navbar-toggler navbar-toggler-right d-md-none"
                type="button"
                data-toggle="collapse"
                data-target="#navbarResponsive"
                aria-controls="navbarResponsive"
                aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="/">Купить/Продать</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">Аренда</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">Аукционы</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">Тендеры</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/">Магазины</a>
                    </li>

                    <asp:LoginView ID="LoginView1" runat="server" ViewStateMode="Disabled">
                        <AnonymousTemplate>
                            <li class="nav-item d-md-none">
                                <a class="nav-link" href="/Account/Login.aspx">Вход</a>
                            </li>
                            </ul>
                        <ul id="#js-popoverContent" class="nav navbar-nav float-right mr-0 d-none d-md-flex">
                            <li class="nav-item">
                                <a id="loginLink" runat="server" class="nav-link login" href="~/Account/Login.aspx">Вход</a>
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
                                    <img class="setting-img" src="/images/settings-icon-50.png" title="Управление" /></a></li>
                                <% } %>

                                <li class="nav-item">
                                    <a class="nav-link" title="Избранное" href="/Favorites.aspx">
                                        <div class="icon icon-favorite"></div>
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
                                <li class="nav-item"><a class="nav-link" href="#" data-action="growl">Growl</a></li>
                                <li class="nav-item">
                                    <asp:LoginStatus CssClass="nav-link" ID="LoginStatus2" runat="server" LogoutAction="Redirect" OnLoggedOut="LoginStatus1_LoggedOut" LogoutText="Выйти" LogoutPageUrl="~/" />
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
                                        <a class="link-header-categories" href="/">Работа</a>
                                    </li>
                                    <li>
                                        <a class="link-header-categories" href="/">Услуги</a>
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
                                                    <li class="popup__first-list"><a href="">Транспорт</a></li>
                                                    <li><a href="">Автомобили</a></li>
                                                    <li><a href="">Мотоциклы и мототехника</a></li>
                                                    <li><a href="">Грузовики и спецтехника</a></li>
                                                    <li><a href="">Водный транспорт</a></li>
                                                    <li><a href="">Запчасти и аксессуары</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Для дома и дачи</a></li>
                                                    <li><a href="">Бытовая техника</a></li>
                                                    <li><a href="">Мебель и интерьер</a></li>
                                                    <li><a href="">Посуда и товары для кухни</a></li>
                                                    <li><a href="">Продукты питания</a></li>
                                                    <li><a href="">Ремонт и строительство</a></li>
                                                    <li><a href="">Растения</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Для бизнеса</a></li>
                                                    <li><a href="">Готовый бизнес</a></li>
                                                    <li><a href="">Оборудование для бизнеса</a></li>
                                                </ul>
                                            </div>
                                            <div class="popup__column">
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Недвижимость</a></li>
                                                    <li><a href="">Квартиры</a></li>
                                                    <li><a href="">Комнаты</a></li>
                                                    <li><a href="">Дома, дачи, коттеджи</a></li>
                                                    <li><a href="">Земельные участки</a></li>
                                                    <li><a href="">Гаражи и машиноместа</a></li>
                                                    <li><a href="">Коммерческая недвижимость</a></li>
                                                    <li><a href="">Недвижимость за рубежом</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Бытовая электроника</a></li>
                                                    <li><a href="">Аудио и видео</a></li>
                                                    <li><a href="">Игры, приставки и программы</a></li>
                                                    <li><a href="">Настольные компьютеры</a></li>
                                                    <li><a href="">Ноутбуки</a></li>
                                                    <li><a href="">Оргтехника и расходники</a></li>
                                                    <li><a href="">Планшеты и электронные книги</a></li>
                                                    <li><a href="">Телефоны</a></li>
                                                    <li><a href="">Товары для компьютера</a></li>
                                                    <li><a href="">Фототехника</a></li>
                                                </ul>
                                            </div>
                                            <div class="popup__column">
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Работа</a></li>
                                                    <li><a href="">Вакансии</a></li>
                                                    <li><a href="">Резюме</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Услуги</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Хобби и отдых</a></li>
                                                    <li><a href="">Билеты и путешествия</a></li>
                                                    <li><a href="">Велосипеды</a></li>
                                                    <li><a href="">Книги и журналы</a></li>
                                                    <li><a href="">Коллекционирование</a></li>
                                                    <li><a href="">Музыкальные инструменты</a></li>
                                                    <li><a href="">Охота и рыбалка</a></li>
                                                    <li><a href="">Спорт и отдых</a></li>
                                                </ul>
                                            </div>
                                            <div class="popup__column">
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Личные вещи</a></li>
                                                    <li><a href="">Одежда, обувь, аксессуары</a></li>
                                                    <li><a href="">Детская одежда и обувь</a></li>
                                                    <li><a href="">Товары для детей и игрушки</a></li>
                                                    <li><a href="">Часы и украшения</a></li>
                                                    <li><a href="">Красота и здоровье</a></li>
                                                </ul>
                                                <ul class="popup__list">
                                                    <li class="popup__first-list"><a href="">Животные</a></li>
                                                    <li><a href="">Собаки</a></li>
                                                    <li><a href="">Кошки</a></li>
                                                    <li><a href="">Птицы</a></li>
                                                    <li><a href="">Аквариум</a></li>
                                                    <li><a href="">Другие животные</a></li>
                                                    <li><a href="">Товары для животных</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>

                        <li class="media list-group-item p-4">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Поиск по объявлениям">
                                <div class="input-group-btn">
                                    <button type="button" class="btn btn-secondary align-self-stretch">
                                        <span>Найти</span>
                                    </button>
                                </div>
                            </div>
                        </li>

                        <li class="media list-group-item p-4">

                            <div class="media-body">
                                <div class="media-heading">
                                    <small class="float-right text-muted">15 025 объявлений</small>
                                    <h6>Бытовая электроника:</h6>
                                </div>

                                <div class="media-body-inline-grid" data-grid="images">
                                    <div style="display: none">
                                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/unsplash_1.jpg">
                                    </div>

                                    <div style="display: none">
                                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_1.jpg">
                                    </div>

                                    <div style="display: none">
                                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_11.jpg">
                                    </div>

                                    <div style="display: none">
                                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/unsplash_2.jpg">
                                    </div>
                                    <div style="display: none">
                                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_2.jpg">
                                    </div>

                                    <div style="display: none">
                                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_4.jpg">
                                    </div>
                                </div>

                                <ul class="media-list mb-2">
                                    <li class="media mb-3">
                                        <img
                                            class="media-object d-flex align-self-start mr-3"
                                            src="assets/img/avatar-fat.jpg">
                                        <div class="media-body">
                                            <strong>Майк Браун: </strong>
                                            Donec id elit non mi porta gravida at eget metus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Donec ullamcorper nulla non metus auctor fringilla. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Sed posuere consectetur est at lobortis.
               
                                        </div>
                                    </li>
                                    <li class="media">
                                        <img
                                            class="media-object d-flex align-self-start mr-3"
                                            src="assets/img/avatar-mdo.png">
                                        <div class="media-body">
                                            <strong>Виктория Золотова: </strong>
                                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.
               
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </li>

                        <li class="media list-group-item p-4">
                            <img
                                class="media-object d-flex align-self-start mr-3"
                                src="assets/img/avatar-fat.jpg">
                            <div class="media-body">
                                <div class="media-body-text">
                                    <div class="media-heading">
                                        <small class="float-right text-muted">12 min</small>
                                        <h6>Майк Браун</h6>
                                    </div>
                                    <p>
                                        Donec id elit non mi porta gravida at eget metus. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
             
                                    </p>
                                </div>
                            </div>
                        </li>

                        <li class="media list-group-item p-4">
                            <img
                                class="media-object d-flex align-self-start mr-3"
                                src="assets/img/avatar-mdo.png">
                            <div class="media-body">
                                <div class="media-heading">
                                    <small class="float-right text-muted">78 объявлений</small>
                                    <h6>Недвижимость:</h6>
                                </div>

                                <p>
                                    Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui.
           
                                </p>

                                <div class="media-body-inline-grid" data-grid="images">
                                    <img style="display: none" data-width="640" data-height="640" data-action="zoom" src="assets/img/instagram_3.jpg">
                                </div>

                                <ul class="media-list">
                                    <li class="media">
                                        <img
                                            class="media-object d-flex align-self-start mr-3"
                                            src="assets/img/avatar-dhg.png">
                                        <div class="media-body">
                                            <strong>Dave Gamache: </strong>
                                            Donec id elit non mi porta gravida at eget metus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Donec ullamcorper nulla non metus auctor fringilla. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Sed posuere consectetur est at lobortis.
               
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="col-lg-3">
                    <div class="alert alert-warning alert-dismissible d-none d-lg-block" role="alert">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <a class="alert-link" href="profile/index.html">Visit your profile!</a> Check your self, you aren't looking well.
     
                    </div>

                    <div class="card mb-4 d-none d-lg-block">
                        <div class="card-body">
                            <h6 class="mb-3">Вы смотрели: <small>· <a href="#">Показать все</a></small></h6>
                            <div data-grid="images" data-target-height="150">
                                <img class="media-object" data-width="640" data-height="640" data-action="zoom" src="assets/img/instagram_2.jpg">
                            </div>
                            <p><strong>It might be time to visit Iceland.</strong> Iceland is so chill, and everything looks cool here. Also, we heard the people are pretty nice. What are you waiting for?</p>
                            <button class="btn btn-outline-primary btn-sm">Buy a ticket</button>
                        </div>
                    </div>

                    <div class="card mb-4 d-none d-lg-block">
                        <div class="card-body">
                            <h6 class="mb-3">Избранное:</h6>
                            <ul class="media-list media-list-stream">
                                <li class="media mb-2">
                                    <img
                                        class="media-object d-flex align-self-start mr-3"
                                        src="assets/img/avatar-fat.jpg">
                                    <div class="media-body">
                                        <strong>Майк Браун</strong> @fat
             
                                    <div class="media-body-actions">
                                        <button class="btn btn-outline-primary btn-sm">
                                            <span class="icon icon-add-user"></span>Follow</button>
                                    </div>
                                    </div>
                                </li>
                                <li class="media">
                                    <a class="media-left" href="#">
                                        <img
                                            class="media-object d-flex align-self-start mr-3"
                                            src="assets/img/avatar-mdo.png">
                                    </a>
                                    <div class="media-body">
                                        <strong>Виктория Золотова</strong> @mdo
             
                                    <div class="media-body-actions">
                                        <button class="btn btn-outline-primary btn-sm">
                                            <span class="icon icon-add-user"></span>Follow</button>

                                    </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="card-footer">
                            Dave really likes these nerds, no one knows why though.
       
                        </div>
                    </div>

                    <div class="card card-link-list">
                        <div class="card-body">
                            © 2018 Bootstrap
         
                        <a href="#">About</a>
                            <a href="#">Help</a>
                            <a href="#">Terms</a>
                            <a href="#">Privacy</a>
                            <a href="#">Cookies</a>
                            <a href="#">Ads </a>
                            <a href="#">Info</a>
                            <a href="#">Brand</a>
                            <a href="#">Blog</a>
                            <a href="#">Status</a>
                            <a href="#">Apps</a>
                            <a href="#">Jobs</a>
                            <a href="#">Advertise</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/chart.js"></script>
        <script src="assets/js/toolkit.js"></script>
        <script src="assets/js/application.js"></script>
        <script>
            // execute/clear BS loaders for docs
            $(function () { while (window.BS && window.BS.loader && window.BS.loader.length) { (window.BS.loader.pop())() } })
        </script>
    </form>
</body>
</html>

