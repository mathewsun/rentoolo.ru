<%@ Page Title="Вход" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Rentoolo.Account.Login" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">

    <title>Вход - Rentoolo</title>

    <script src='https://www.google.com/recaptcha/api.js'></script>
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
    <link href="/assets/css/toolkit.css" rel="stylesheet">

    <link href="/assets/css/application.css" rel="stylesheet">
    <link href="/assets/css/additional.css?78" rel="stylesheet">


    <style>
        body {
            width: 1px;
            min-width: 100%;
            *width: 100%;
        }
    </style>

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

<body>

    <div class="container-fluid container-fill-height">
        <div class="container-content-middle">
            <form id="form1" role="form" class="mx-auto text-center app-login-form" runat="server">
                <asp:Login ID="Login1" runat="server" ViewStateMode="Disabled" RenderOuterTable="false" OnLoggingIn="On_LoggingIn" OnAuthenticate="Authenticate" DisplayRememberMe="False">
                    <LayoutTemplate>
                        <a href="/" class="app-brand mb-5">
                            <span class="logo-text" style="margin-right: -3px;">Rent</span>
                            <img class="logo-img" src="/assets/img/yellow-green.png" alt="brand">
                            <span class="logo-text" style="margin-left: -3px;">lo</span>
                        </a>

                        <div class="form-group">
                            <asp:TextBox runat="server" CssClass="form-control login-input" ID="UserName" placeholder="Username" />
                        </div>
                        <div class="text-danger">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorUserName" runat="server" ControlToValidate="UserName" CssClass="field-validation-error" Display="Dynamic" ErrorMessage="Введите имя пользователя" />
                        </div>

                        <div class="form-group mb-3">
                            <asp:TextBox runat="server" CssClass="form-control login-input" ID="Password" TextMode="Password" placeholder="Пароль" />
                        </div>
                        <div class="text-danger">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPassword" runat="server" ControlToValidate="Password" CssClass="field-validation-error" Display="Dynamic" ErrorMessage="Введите пароль" />
                        </div>

                        <%if (!IsLocalhost)
                            { %>
                        <div class="form-group">
                            <div class="g-recaptcha" data-sitekey="6Lf4W6QUAAAAAPK2AR7Ms8SsI9_KuJ0l8XZWaTWD"></div>
                        </div>
                        <%} %>

                        <div class="mb-5">
                            <asp:Button ID="ButtonLogin" runat="server" CssClass="btn btn-primary" CommandName="Login" Text="Вход" />
                            <button type="button" class="btn btn-secondary" onclick="location.href='/Account/SignUp?ReturnUrl='">Регистрация</button>
                        </div>

                        <footer class="screen-login">
                            <a href="#" class="text-muted">Забыли пароль</a>
                        </footer>
                        <div class="col-md-4">
                            <section id="socialLoginForm">
                                <uc:OpenAuthProviders runat="server" ID="OpenAuthLogin" />
                            </section>
                        </div>
                    </LayoutTemplate>
                </asp:Login>
            </form>
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
    </script>
</body>
</html>
