﻿<%@ Page Title="Регистрация" Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="Rentoolo.Account.SignUp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">

    <title>Регистрация</title>

    <script src='https://www.google.com/recaptcha/api.js'></script>
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
    <link href="/assets/css/toolkit.css" rel="stylesheet">

    <link href="/assets/css/application.css" rel="stylesheet">
    <link href="/assets/css/additional.css?7" rel="stylesheet">

    <style>
        body {
            width: 1px;
            min-width: 100%;
            *width: 100%;
        }
    </style>

</head>

<body>

    <div class="container-fluid container-fill-height">
        <div class="container-content-middle">
            <form id="form1" role="form" class="mx-auto text-center app-login-form" runat="server">
                <asp:CreateUserWizard runat="server" ID="RegisterUser" ViewStateMode="Disabled" OnCreatingUser="RegisterUser_CreatingUser" OnCreatedUser="RegisterUser_CreatedUser">
                    <LayoutTemplate>
                        <asp:PlaceHolder runat="server" ID="wizardStepPlaceholder" />
                        <asp:PlaceHolder runat="server" ID="navigationPlaceholder" />
                    </LayoutTemplate>
                    <WizardSteps>
                        <asp:CreateUserWizardStep runat="server" ID="RegisterUserWizardStep">
                            <ContentTemplate>
                                <a href="/" class="app-brand mb-5">
                                    <span class="logo-text" style="margin-right: -3px;">Rent</span>
                                    <img class="logo-img" src="/assets/img/yellow-green.png" alt="brand">
                                    <span class="logo-text" style="margin-left: -3px;">lo</span>
                                </a>

                                <div class="form-group">
                                    <asp:TextBox runat="server" CssClass="form-control login-input" ID="UserName" placeholder="Username" />
                                    <div class="div-validation-error">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorUserName" runat="server" ControlToValidate="UserName" CssClass="field-validation-error" ErrorMessage="*" /></div>
                                </div>

                                <div class="form-group">
                                    <asp:TextBox runat="server" CssClass="form-control login-input" ID="Email" placeholder="Email" />
                                    <div class="div-validation-error">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Email" CssClass="field-validation-error" ErrorMessage="*" /></div>
                                </div>

                                <div class="form-group">
                                    <asp:TextBox runat="server" CssClass="form-control login-input" ID="Password" TextMode="Password" placeholder="Пароль" />
                                    <div class="div-validation-error">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorPassword" runat="server" ControlToValidate="Password" CssClass="field-validation-error" ErrorMessage="*" /></div>
                                </div>

                                <div class="form-group login-confirm">
                                    <asp:TextBox runat="server" CssClass="form-control login-input" ID="ConfirmPassword" TextMode="Password" placeholder="Подтверждение" />
                                    <div class="div-validation-error">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorConfirmPassword" runat="server" ControlToValidate="ConfirmPassword" CssClass="field-validation-error" Display="Dynamic" ErrorMessage="*" />
                                        <asp:CompareValidator ID="CompareValidatorConfirmPassword" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" CssClass="field-validation-error" Display="Dynamic" ErrorMessage="*" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="g-recaptcha" data-sitekey="6Lf4W6QUAAAAAPK2AR7Ms8SsI9_KuJ0l8XZWaTWD"></div>
                                </div>

                                <div class="mb-5">
                                    <asp:Button ID="Button1" runat="server" CssClass="btn btn-primary" CommandName="MoveNext" Text="Зарегистрироваться" />
                                </div>

                                <footer class="screen-login">
                                    <a href="#" class="text-muted">Забыли пароль</a>
                                </footer>
                            </ContentTemplate>
                            <CustomNavigationTemplate />
                        </asp:CreateUserWizardStep>
                    </WizardSteps>
                </asp:CreateUserWizard>
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