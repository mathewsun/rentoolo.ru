<%@ Page Title="Смена пароля" Language="C#" MasterPageFile="~/SiteBalance.Master" AutoEventWireup="true" CodeBehind="Manage.aspx.cs" Inherits="Rentoolo.Account.Manage" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>

    <asp:PlaceHolder runat="server" ID="successMessage" Visible="false" ViewStateMode="Disabled">
        <p class="message-success"><%: SuccessMessage %></p>
    </asp:PlaceHolder>

    <p><span class="blackText">Вы вошли как <strong><%: User.Identity.Name %></strong>.</span></p>

    <asp:PlaceHolder runat="server" ID="setPassword" Visible="false">
        <p>
            You do not have a local password for this site. Add a local
                password so you can log in without an external login.
        </p>
        <ol>
            <li>
                <asp:Label runat="server" AssociatedControlID="password">Пароль</asp:Label>
                <asp:TextBox runat="server" ID="password" TextMode="Password" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="password"
                    CssClass="field-validation-error" ErrorMessage="The password field is required."
                    Display="Dynamic" ValidationGroup="SetPassword" />

                <asp:ModelErrorMessage runat="server" ModelStateKey="NewPassword" AssociatedControlID="password"
                    CssClass="field-validation-error" SetFocusOnError="true" />

            </li>
            <li>
                <asp:Label runat="server" AssociatedControlID="confirmPassword">Подтверждение пароля</asp:Label>
                <asp:TextBox runat="server" ID="confirmPassword" TextMode="Password" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="confirmPassword"
                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The confirm password field is required."
                    ValidationGroup="SetPassword" />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="confirmPassword"
                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The password and confirmation password do not match."
                    ValidationGroup="SetPassword" />
            </li>
        </ol>
        <asp:Button runat="server" Text="Set Password" ValidationGroup="SetPassword" OnClick="setPassword_Click" />
    </asp:PlaceHolder>

    <asp:PlaceHolder runat="server" ID="changePassword" Visible="false">
        <asp:ChangePassword runat="server" CancelDestinationPageUrl="~/" ViewStateMode="Disabled" RenderOuterTable="false" SuccessPageUrl="Manage.aspx?m=ChangePwdSuccess">
            <ChangePasswordTemplate>
                <p class="validation-summary-errors">
                    <asp:Literal runat="server" ID="FailureText" />
                </p>

                <table class="elementsTable">
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="CurrentPasswordLabel" AssociatedControlID="CurrentPassword">Текущий пароль</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="CurrentPassword" CssClass="passwordEntry" TextMode="Password" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="CurrentPassword"
                                CssClass="field-validation-error" ErrorMessage="Введите текущий праоль."
                                ValidationGroup="ChangePassword" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="NewPasswordLabel" AssociatedControlID="NewPassword">Новый пароль</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="NewPassword" CssClass="passwordEntry" TextMode="Password" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="NewPassword"
                                CssClass="field-validation-error" ErrorMessage="Введите новый пароль."
                                ValidationGroup="ChangePassword" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="ConfirmNewPasswordLabel" AssociatedControlID="ConfirmNewPassword">Подтверждение пароля</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="ConfirmNewPassword" CssClass="passwordEntry" TextMode="Password" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ConfirmNewPassword"
                                CssClass="field-validation-error" Display="Dynamic" ErrorMessage="Подтвердите новый пароль."
                                ValidationGroup="ChangePassword" />
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword"
                                CssClass="field-validation-error" Display="Dynamic" ErrorMessage="Пароли не совпадают."
                                ValidationGroup="ChangePassword" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="Button1" runat="server" CommandName="ChangePassword" CssClass="button" Text="Сменить пароль" ValidationGroup="ChangePassword" />
                        </td>
                    </tr>
                </table>
            </ChangePasswordTemplate>
        </asp:ChangePassword>
    </asp:PlaceHolder>
</asp:Content>
