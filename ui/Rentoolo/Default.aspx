<%@ Page Title="Rentoolo" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Rentoolo._Default" EnableEventValidation="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="/images/yellow-green.ico">

    <title>Rentoolo - Ваши объявления</title>
    <meta property="og:title" content="Rentoolo - Ваши объявления" />
    <meta property="mrc__share_title" content="Rentoolo - Ваши объявления" />
    <meta property="twitter:title" content="Rentoolo - Ваши объявления" />
    <meta property="vk:image" content="http://www.Rentoolo.ru/images/banner_1.jpg" />
    <meta property="og:image" content="http://www.Rentoolo.ru/images/banner_1.jpg" />
    <meta property="twitter:image" content="http://www.Rentoolo.ru/images/banner_1.jpg" />
    <meta property="image" content="http://www.Rentoolo.ru/images/banner_1.jpg" />

    <link href='/content/css.css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
    <link href="/content/toolkit.css" rel="stylesheet">

    <link href="/content/application.css" rel="stylesheet">

    <style>
        /* note: this is a hack for ios iframe for bootstrap themes shopify page */
        /* this chunk of css is not part of the toolkit :) */
        body {
            width: 1px;
            min-width: 100%;
            *width: 100%;
        }
    </style>

</head>

<body class="bob">

    <div class="bon" id="app-growl"></div>

    <nav class="ck pt adq py tk app-navbar">

        <a class="e" href="/">
            <span class="logo-text" style="margin-right: -3px;">Rent</span>
            <img src="images/yellow-green.png" alt="brand">
            <span class="logo-text" style="margin-left: -3px;">lo</span>
        </a>

        <button
            class="pp bpn vm"
            type="button"
            data-toggle="collapse"
            data-target="#navbarResponsive"
            aria-controls="navbarResponsive"
            aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="pq"></span>
        </button>

        <div class="collapse f" id="navbarResponsive">
            <ul class="navbar-nav ahq">
                <li class="pi active">
                    <a class="pg" href="index.html">Купить/Продать</a>
                </li>
                <li class="pi">
                    <a class="pg" href="profile/index.html">Снять/Сдать</a>
                </li>
                <li class="pi">
                    <a class="pg" href="/Help.aspx">Помощь</a>
                </li>
            </ul>

            <button class="cg create-advertisement ok">Подать объявление</button>


            <form id="Form1" runat="server">
                <asp:LoginView ID="LoginView1" runat="server" ViewStateMode="Disabled">
                    <AnonymousTemplate>
                        <ul class="navbar-nav ahq">
                            <li class="pi"><a id="loginLink" class="login" runat="server" href="~/Account/Login.aspx">Вход</a></li>
                        </ul>
                    </AnonymousTemplate>
                    <LoggedInTemplate>
                        <ul id="#js-popoverContent" class="nav navbar-nav acx aek d-none vt">
                            <% if (Page.User.IsInRole("Administrator")
                                                                                                                    || Page.User.IsInRole("CashOutManager"))
                                { %>
                            <li><a id="A1" runat="server" href="~/Admin/Admin.aspx">
                                <img class="setting-img" src="/images/settings-icon-50.png" title="Управление" /></a></li>
                            <% } %>

                            <li class="pi">
                                <a class="g pg" href="/Favorites.aspx">
                                    <img title="Избранное" class="favorite" src="/images/favorite_2.png"
                                        onmouseover="this.src='/images/favorite_2_blue.png'"
                                        onmouseout="this.src='/images/favorite_2.png'" />
                                </a>
                            </li>
                            <li class="pi">
                                <a class="g pg" href="notifications/index.html">
                                    <span class="h azy"></span>
                                </a>
                            </li>
                            <li class="pi afb">
                                <button class="cg bpo bpp boi" data-toggle="popover">
                                    <img class="us" src="/images/avatar-dhg.png">
                                </button>
                            </li>
                        </ul>

                        <ul class="nav navbar-nav d-none" id="js-popoverContent">
                            <li class="pi"><a class="pg" href="#" data-action="growl">Growl</a></li>
                            <li class="pi"><a class="pg" href="login/index.html">Logout</a></li>
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
            </form>



        </div>
    </nav>

    <div class="cd fade" id="userModal" tabindex="-1" role="dialog" aria-labelledby="bpr" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="d">
                    <h4 class="modal-title">Users</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>

                <div class="modal-body afx">
                    <div class="axw">
                        <ul class="bow cj ca">
                            <li class="b">
                                <div class="rv ady">
                                    <img class="bos vb yb aff" src="images/avatar-fat.jpg">
                                    <div class="rw">
                                        <button class="cg ns ok acx">
                                            <span class="c bps"></span>Follow
                                        </button>
                                        <strong>Jacob Thornton</strong>
                                        <p>@fat - San Francisco</p>
                                    </div>
                                </div>
                            </li>
                            <li class="b">
                                <div class="rv ady">
                                    <img class="bos vb yb aff" src="images/avatar-dhg.png">
                                    <div class="rw">
                                        <button class="cg ns ok acx">
                                            <span class="c bps"></span>Follow
                                        </button>
                                        <strong>Dave Gamache</strong>
                                        <p>@dhg - Palo Alto</p>
                                    </div>
                                </div>
                            </li>
                            <li class="b">
                                <div class="rv ady">
                                    <img class="bos vb yb aff" src="images/avatar-mdo.png">
                                    <div class="rw">
                                        <button class="cg ns ok acx">
                                            <span class="c bps"></span>Follow
                                        </button>
                                        <strong>Mark Otto</strong>
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


    <div class="by aha ahl">
        <div class="dp">
            <div class="fj">

                <div class="pz vp vy afo">
                    <div class="qa">
                        <h6 class="afh">Категории:</h6>
                        <ul class="dc axg">
                            <li><span class="axc h bgz aff"></span><a href="#">Авто</a>
                            <li><span class="axc h bfq aff"></span><a href="#">Недвижимость</a>
                            <li><span class="axc h bnc aff"></span><a href="#">Работа</a>
                            <li><span class="axc h bgz aff"></span><a href="#">Услуги</a>
                            <li><span class="axc h bgz aff"></span><a href="#">Личные вещи</a>
                            <li><span class="axc h bgz aff"></span><a href="#">Для дома и дачи</a>
                            <li><span class="axc h bgz aff"></span><a href="#">Бытовая электроника</a>
                            <li><span class="axc h ban aff"></span><a href="#">Хобби и отдых</a>
                            <li><span class="axc h bfa aff"></span><a href="#">Животные</a>
                            <li><span class="axc h bgz aff"></span><a href="#">Бизнес</a>
                        </ul>
                    </div>
                </div>

                <div class="pz vp vy afo">
                    <div class="qa">
                        <h6 class="afh">Похожие товары</h6>
                        <div data-grid="images" data-target-height="150">
                            <div>
                                <img data-width="640" data-height="640" data-action="zoom" src="images/instagram_5.jpg">
                            </div>

                            <div>
                                <img data-width="640" data-height="640" data-action="zoom" src="images/instagram_6.jpg">
                            </div>

                            <div>
                                <img data-width="640" data-height="640" data-action="zoom" src="images/instagram_7.jpg">
                            </div>

                            <div>
                                <img data-width="640" data-height="640" data-action="zoom" src="images/instagram_8.jpg">
                            </div>

                            <div>
                                <img data-width="640" data-height="640" data-action="zoom" src="images/instagram_9.jpg">
                            </div>

                            <div>
                                <img data-width="640" data-height="640" data-action="zoom" src="images/instagram_10.jpg">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="fm">

                <ul class="ca bow box afo">

                    <li class="rv b agz">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Поиск">
                            <div class="bpt">
                                <button type="button" class="cg ns yf">
                                    Ok
                                </button>
                            </div>
                        </div>
                    </li>

                    <li class="rv b agz">

                        <div class="rw">
                            <div class="bpb">
                                <small class="acx axc">15 025 объявлений</small>
                                <h6>Бытовая электроника:</h6>
                            </div>

                            <div class="boy" data-grid="images">
                                <div style="display: none">
                                    <img data-action="zoom" data-width="500" data-height="500" src="images/unsplash_1.jpg">
                                </div>
                                <div style="display: none">
                                    <img data-action="zoom" data-width="500" data-height="500" src="images/instagram_1.jpg">
                                </div>

                                <div style="display: none">
                                    <img data-action="zoom" data-width="500" data-height="500" src="images/instagram_13.jpg">
                                </div>

                                <div style="display: none">
                                    <img data-action="zoom" data-width="500" data-height="500" src="images/unsplash_2.jpg">
                                </div>
                                <div style="display: none">
                                    <img data-action="zoom" data-width="500" data-height="500" src="images/instagram_1.jpg">
                                </div>

                                <div style="display: none">
                                    <img data-action="zoom" data-width="500" data-height="500" src="images/instagram_13.jpg">
                                </div>

                            </div>

                        </div>
                    </li>

                    <li class="rv b agz">
                        <div class="rw">
                            <div class="bpb">
                                <small class="acx axc">78 объявлений</small>
                                <h6>Недвижимость:</h6>
                            </div>

                            <p>
                                Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui.
                            </p>

                            <div class="boy" data-grid="images">
                                <img style="display: none" data-width="640" data-height="640" data-action="zoom" src="images/instagram_3.jpg">
                            </div>

                            <ul class="bow">
                                <li class="rv">
                                    <img
                                        class="bos vb yb aff"
                                        src="images/avatar-dhg.png">
                                    <div class="rw">
                                        <strong>Dave Gamache: </strong>
                                        Donec id elit non mi porta gravida at eget metus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Donec ullamcorper nulla non metus auctor fringilla. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Sed posuere consectetur est at lobortis.
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="fj">

                <div class="pz afo d-none vy">
                    <div class="qa">
                        <h6 class="afh">Вы смотрели: <small>· <a href="#">Показать все</a></small></h6>
                        <div data-grid="images" data-target-height="150">
                            <img class="bos" data-width="640" data-height="640" data-action="zoom" src="images/instagram_2.jpg">
                        </div>
                        <p><strong>It might be time to visit Iceland.</strong> Iceland is so chill, and everything looks cool here. Also, we heard the people are pretty nice. What are you waiting for?</p>
                        <button class="cg nz ok">Buy a ticket</button>
                    </div>
                </div>

                <div class="pz afo d-none vy">
                    <div class="qa">
                        <h6 class="afh">Избранное:</h6>
                        <ul class="bow box">
                        </ul>
                    </div>
                    <div class="qg">
                        Dave really likes these nerds, no one knows why though.
                    </div>
                </div>

                <div class="pz bpm">
                    <div class="qa">
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


    <script src="/Scripts/jquery.min.js"></script>
    <script src="/Scripts/popper.min.js"></script>
    <script src="/Scripts/chart.js"></script>
    <script src="/Scripts/toolkit.js"></script>
    <script src="/Scripts/application.js"></script>
    <script>
        // execute/clear BS loaders for docs
        $(function () { while (window.BS && window.BS.loader && window.BS.loader.length) { (window.BS.loader.pop())() } })
    </script>

</body>
</html>
