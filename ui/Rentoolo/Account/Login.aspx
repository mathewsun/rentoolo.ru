<%@ Page Title="Вход" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Rentoolo.Account.Login" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content runat="server" ID="HeaderContent" ContentPlaceHolderID="HeadContent">
    <script src='https://www.google.com/recaptcha/api.js'></script>
</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h2>Войдите в систему</h2>
    <asp:Login runat="server" ViewStateMode="Disabled" RenderOuterTable="false" OnLoggingIn="On_LoggingIn" DisplayRememberMe="False" OnLoggedIn="Unnamed1_LoggedIn">
        <LayoutTemplate>
            <p class="validation-summary-errors">
                <asp:Literal runat="server" ID="FailureText" />
            </p>
            <table class="elementsTable loginTable">
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" AssociatedControlID="UserName">Пользователь</asp:Label>
                    </td>
                    <td>
                        <asp:TextBox runat="server" CssClass="user-login" ID="UserName" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserName" CssClass="field-validation-error" ErrorMessage="Заполните." />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label2" runat="server" AssociatedControlID="Password">Пароль</asp:Label>
                    </td>
                    <td>
                        <asp:TextBox runat="server" CssClass="user-login" ID="Password" TextMode="Password" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Password" CssClass="field-validation-error" ErrorMessage="Заполните." />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div class="g-recaptcha" data-sitekey="6Lf4W6QUAAAAAPK2AR7Ms8SsI9_KuJ0l8XZWaTWD"></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="Button1" runat="server" CssClass="button button-login" CommandName="Login" Text="Вход" />
                    </td>
                </tr>
            </table>
        </LayoutTemplate>
    </asp:Login>
    <p>
        <asp:HyperLink runat="server" ID="RegisterHyperLink" NavigateUrl="~/Account/Register.aspx" CssClass="registrate-button" ViewStateMode="Disabled">Зарегистрируйтесь</asp:HyperLink><span class="registrate-text">, если нет аккаунта.</span>
    </p>

    <script type="text/javascript">
        jQuery(document).ready(function ($) {
            var topMenu = $("#top-navigation"),
            menuItems = topMenu.find("a");
            menuItems.parent().removeClass("active");
            menuItems.filter("[id*='loginLink']").parent().addClass("active");
        });
    </script>

</asp:Content>
