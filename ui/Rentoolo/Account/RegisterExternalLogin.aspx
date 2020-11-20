<%@ Page Language="C#" Title="Register an external login" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterExternalLogin.aspx.cs" Inherits="Rentoolo.Account.RegisterExternalLogin" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1>Register with your <%: ProviderDisplayName %> account</h1>
        <h2><%: ProviderUserName %>.</h2>
    </hgroup>


    <asp:ModelErrorMessage runat="server" ModelStateKey="Provider" CssClass="field-validation-error" />

     

    <asp:PlaceHolder runat="server" ID="userNameForm">
        <fieldset>

            <legend>Association Form</legend>
            <p>
                Вы прошли аутентификацию с <strong><%: ProviderDisplayName %></strong> как
                <strong><%: ProviderUserName %></strong>.Пожалуйста, введите ниже имя пользователя, пароль для текущего сайта и нажмите кнопку «Войти».

            </p>

            <ol>
                <li class="userName">
                    <asp:Label runat="server" AssociatedControlID="userName">User name</asp:Label>
                    <asp:TextBox runat="server" ID="userName" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="userName"
                        Display="Dynamic" ErrorMessage="User name is required" ValidationGroup="NewUser" />
                    <asp:ModelErrorMessage runat="server" ModelStateKey="UserName" CssClass="field-validation-error" />
                </li>
                <li class="Password">
                    <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
                    <asp:TextBox runat="server" ID="Password" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Password"
                        Display="Dynamic" ErrorMessage="Введите пароль" ValidationGroup="Password" />
                    <asp:ModelErrorMessage runat="server" ModelStateKey="Password" CssClass="field-validation-error" />
                </li>
                <li class="Email">
                    <asp:Label runat="server" AssociatedControlID="Email">Email</asp:Label>
                    <asp:TextBox runat="server" ID="Email" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                        Display="Dynamic" ErrorMessage="Введите Email" ValidationGroup="Email" />
                    <asp:ModelErrorMessage runat="server" ModelStateKey="Email" CssClass="field-validation-error" />
                </li>

            </ol>
            <asp:Button runat="server" Text="Log in" ValidationGroup="NewUser" OnClick="logIn_Click" />
            <asp:Button runat="server" Text="Cancel" CausesValidation="false" OnClick="cancel_Click" />
        </fieldset>
    </asp:PlaceHolder>
</asp:Content>
